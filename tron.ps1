<#
    Tron - Automated System Maintenance
    Generated: 12/25/2025 13:31:56
#>
# --- PARAMETERS ---
param(
    [switch]$DryRun,
    [switch]$NonInteractive,
    [switch]$AutoReboot
)
$ErrorActionPreference = 'Stop'

# --- EMBEDDED CONFIG ---
$Global:DefaultSettings = '{
    "LogPath": "C:\\Logs\\Tron\\neotron.log",
    "AutoRebootDelay": 15,
    "Stages": {
        "Prep": {
            "Enabled": true
        },
        "TempClean": {
            "Enabled": true
        },
        "Debloat": {
            "Enabled": true
        },
        "Disinfect": {
            "Enabled": true
        },
        "Repair": {
            "Enabled": true
        },
        "Optimize": {
            "Enabled": true
        }
    }
}' | ConvertFrom-Json

$Global:AllowLists = '{
    "ProtectedApps": [
        "Microsoft.WindowsCalculator",
        "Microsoft.WindowsStore",
        "Microsoft.Windows.Photos",
        "Microsoft.WindowsCamera",
        "Microsoft.WindowsAlarms",
        "Microsoft.MicrosoftStickyNotes"
    ]
}' | ConvertFrom-Json

# --- MODULE: logging.ps1 ---
function Initialize-TronLogging {
    param([string]$Path)
    
    $Global:TronLogPath = $Path
    $parent = Split-Path $Path -Parent
    if (-not (Test-Path $parent)) { New-Item $parent -ItemType Directory -Force | Out-Null }
    
    # Start Transcript for black-box recording
    Start-Transcript -Path "$Path.transcript.log" -Force | Out-Null
}

function Write-TronLog {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO","WARN","ERROR","SUCCESS","DEBUG")]$Level = "INFO"
    )

    $ts = Get-Date -Format "HH:mm:ss"
    $line = "[$ts] [$Level] $Message"
    
    # Color logic
    $color = switch ($Level) {
        "INFO" { "White" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "DEBUG" { "Gray" }
    }
    
    Write-Host "[$Level] $Message" -ForegroundColor $color
    
    if ($Global:TronLogPath) {
        Add-Content -Path $Global:TronLogPath -Value $line
    }
}


# --- MODULE: elevation.ps1 ---
function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-Elevation {
    if (-not (Test-IsAdmin)) {
        Write-Warning "Tron requires Administrator privileges."
        if ($Global:NonInteractive) {
            Throw "Elevation required in NonInteractive mode."
        }
        
        # Self-Elevate
        Write-Host "Relaunching as Administrator..." -ForegroundColor Yellow
        $exe = (Get-Process -Id $PID).Path
        $args = $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key)" }
        
        Start-Process $exe -ArgumentList "-File `"$PSCommandPath`" $args" -Verb RunAs
        Exit
    }
}


# --- STAGE: 00_prep.ps1 ---
function Invoke-Stage00_Prep {
    Write-TronLog -Level INFO -Message "Stage 0: Prep - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would check VSS and Create Restore Point."; return }

    # 1. Check Volume Shadow Copy Service (VSS)
    try {
        $vss = Get-Service "vss"
        if ($vss.Status -ne 'Running') {
             Write-TronLog -Level INFO -Message "Starting Volume Shadow Copy Service..."
             Set-Service "vss" -StartupType Manual
             Start-Service "vss"
        }
    } catch {
        Write-TronLog -Level WARN -Message "Failed to query/start VSS service: $_"
    }

    # 2. Create System Restore Point
    try {
        Write-TronLog -Level INFO -Message "Creating System Restore Point..."
        Checkpoint-Computer -Description "Tron Pre-Run $(Get-Date -Format 'yyyy-MM-dd')" -RestorePointType "MODIFY_SETTINGS" -ErrorAction Stop
        Write-TronLog -Level SUCCESS -Message "Restore Point Created."
    } catch {
        Write-TronLog -Level ERROR -Message "Failed to create Restore Point: $_"
        # We don't exit; continuing is usually preferred
    }

    # 3. SMART Disk Check
    Write-TronLog -Level INFO -Message "Checking Disk Health (SMART)..."
    try {
        $disks = Get-PhysicalDisk | Where-Object { $_.HealthStatus -ne 'Healthy' }
        if ($disks) {
            foreach ($d in $disks) {
                Write-TronLog -Level ERROR -Message "SMART FAILURE DETECTED: Drive $($d.DeviceId) ($($d.FriendlyName)) status is $($d.HealthStatus)"
            }
            Write-TronLog -Level WARN -Message "Hardware errors detected! Tron operations may be risky."
            Start-Sleep -Seconds 5
        } else {
             Write-TronLog -Level SUCCESS -Message "SMART Status: Healthy on all drives."
        }
    } catch {
        # Fallback to WMI if Get-PhysicalDisk (Storage module) fails (e.g. older Win10/Win8)
         Write-TronLog -Level DEBUG -Message "Storage Module failed, trying WMI..."
         try {
            $wmiDisks = Get-WmiObject -Namespace "root\wmi" -Class MSStorageDriver_FailurePredictStatus -ErrorAction Stop
            if ($wmiDisks | Where-Object { $_.PredictFailure }) {
                 Write-TronLog -Level ERROR -Message "SMART FAILURE DETECTED (WMI)."
            } else {
                 Write-TronLog -Level SUCCESS -Message "SMART Status: Healthy (WMI)."
            }
         } catch {
             Write-TronLog -Level WARN -Message "Could not query SMART status."
         }
    }
}


# --- STAGE: 01_tempclean.ps1 ---
function Invoke-Stage01_TempClean {
    Write-TronLog -Level INFO -Message "Stage 1: TempClean - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would clean Temp and Event Logs."; return }

    # 1. Standard Temp Cleaning
    $tempPaths = @("$env:TEMP", "$env:SystemRoot\Temp", "$env:SystemRoot\Prefetch")
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            Write-TronLog -Level INFO -Message "Cleaning: $path"
            Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        }
    }

    # 2. Advanced Disk Cleanup (cleanmgr /sageset pattern)
    # We write registry keys to pre-select items for 'cleanmgr /sagerun:1337'
    Write-TronLog -Level INFO -Message "Configuring Native Disk Cleanup (cleanmgr)..."
    $StateFlagsPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
    $Handlers = Get-ChildItem -Path $StateFlagsPath -ErrorAction SilentlyContinue

    foreach ($Handler in $Handlers) {
        # StateFlags1337 = 2 (Selected)
        try {
            New-ItemProperty -Path $Handler.PSPath -Name "StateFlags1337" -Value 2 -PropertyType DWORD -Force -ErrorAction SilentlyContinue | Out-Null
        } catch {}
    }

    Write-TronLog -Level INFO -Message "Executing Disk Cleanup..."
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1337" -NoNewWindow -Wait

    # 3. Clear Event Logs
    Write-TronLog -Level INFO -Message "Clearing Windows Event Logs..."
    Get-EventLog -List | ForEach-Object {
        try { Clear-EventLog -LogName $_.Log -ErrorAction SilentlyContinue } catch {}
    }
    
    # Modern Event Logs (wevtutil) - Filtered common ones
    # A full loop over all providers is slow, targeting key ones:
    $ModernLogs = @("Application", "System", "Security", "Setup", "Microsoft-Windows-Diagnostics-Performance/Operational")
    foreach ($log in $ModernLogs) {
        cmd.exe /c "wevtutil cl $log" | Out-Null
    }

    Write-TronLog -Level SUCCESS -Message "TempClean Complete."
}


# --- STAGE: 02_debloat.ps1 ---
function Invoke-Stage02_Debloat {
    Write-TronLog -Level INFO -Message "Stage 2: Debloat - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would remove Appx Packages not in allowlist."; return }

    # 1. Load AllowList
    if (-not $Global:AllowLists.ProtectedApps) {
        Write-TronLog -Level WARN -Message "No AllowList found! Aborting Debloat to prevent system damage."
        return
    }
    $Allowed = $Global:AllowLists.ProtectedApps

    # 2. Debloat Provisioned Packages (System-wide)
    Write-TronLog -Level INFO -Message "Scanning Provisioned Packages..."
    $Provisioned = Get-AppxProvisionedPackage -Online
    
    foreach ($App in $Provisioned) {
        if ($App.DisplayName -notin $Allowed) {
            Write-TronLog -Level INFO -Message "Removing Provisioned App: $($App.DisplayName)..."
            try {
                Remove-AppxProvisionedPackage -Online -PackageName $App.PackageName -ErrorAction Stop | Out-Null
            } catch {
                Write-TronLog -Level DEBUG -Message "Failed to remove $($App.DisplayName): $_"
            }
        }
    }

    # 3. Debloat Installed Packages (Current User)
    Write-TronLog -Level INFO -Message "Scanning User Packages..."
    $UserApps = Get-AppxPackage -PackageTypeFilter Main
    
    foreach ($App in $UserApps) {
        # Check against simple name (e.g. Microsoft.WindowsCalculator)
        if ($App.Name -notin $Allowed -and $App.Values.NonRemovable -ne $true) {
             Write-TronLog -Level INFO -Message "Removing User App: $($App.Name)..."
             try {
                Remove-AppxPackage -Package $App.PackageFullName -ErrorAction Stop
             } catch {
                Write-TronLog -Level DEBUG -Message "Failed to remove $($App.Name): $_"
             }
        }
    }

    Write-TronLog -Level SUCCESS -Message "Debloat Complete."
}


# --- STAGE: 03_disinfect.ps1 ---
function Invoke-Stage03_Disinfect {
    Write-TronLog -Level INFO -Message "Stage 3: Disinfect - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would run Windows Defender Full Scan."; return }

    # 1. Update Signatures
    Write-TronLog -Level INFO -Message "Updating Defender Signatures..."
    try {
        Update-MpSignature -ErrorAction Stop
        Write-TronLog -Level SUCCESS -Message "Signatures Updated."
    } catch {
        Write-TronLog -Level WARN -Message "Signature Update Failed: $_"
    }

    # 2. Run Full Scan
    Write-TronLog -Level INFO -Message "Starting Windows Defender Full Scan (This may take a while)..."
    try {
        $scan = Start-MpScan -ScanType FullScan -PassThru
        # Note: Start-MpScan is synchronous by default unless -AsJob is used
        Write-TronLog -Level SUCCESS -Message "Defender Scan Complete."
    } catch {
        Write-TronLog -Level ERROR -Message "Defender Scan Failed: $_"
    }

    # 3. Optional: Trigger Offline Scan (Boot Time)
    # This forces a reboot, so strict check on Config
    if ($Global:DefaultSettings.Stages.Disinfect.RunOfflineScan) {
        Write-TronLog -Level WARN -Message "Scheduling Windows Defender OFFLINE Scan (Reboot Required)..."
        try {
            Start-MpWDOScan
            Write-TronLog -Level SUCCESS -Message "Offline Scan Scheduled."
        } catch {
            Write-TronLog -Level ERROR -Message "Failed to schedule Offline Scan: $_"
        }
    }
}


# --- STAGE: 04_repair.ps1 ---
function Invoke-Stage04_Repair {
    Write-TronLog -Level INFO -Message "Stage 4: Repair - Initializing..."
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would run SFC, DISM, and Windows Update."; return }

    # 1. Self-Healing System Repair Loop
    Write-TronLog -Level INFO -Message "Starting SFC Scan..."
    $sfcArgs = "/scannow"
    $sfcProc = Start-Process -FilePath "sfc.exe" -ArgumentList $sfcArgs -Wait -NoNewWindow -PassThru
    
    if ($sfcProc.ExitCode -ne 0) {
        Write-TronLog -Level WARN -Message "SFC found corruption (Exit Code: $($sfcProc.ExitCode)). Attempting DISM Repair..."
        
        # Run DISM RestoreHealth
        $dismArgs = "/Online /Cleanup-Image /RestoreHealth"
        Start-Process -FilePath "dism.exe" -ArgumentList $dismArgs -Wait -NoNewWindow
        
        # Re-verify with SFC
        Write-TronLog -Level INFO -Message "Verifying repairs with second SFC scan..."
        Start-Process -FilePath "sfc.exe" -ArgumentList $sfcArgs -Wait -NoNewWindow
    } else {
        Write-TronLog -Level SUCCESS -Message "SFC: No integrity violations found."
    }

    # 2. Windows Update via COM (Native, No Module)
    Write-TronLog -Level INFO -Message "Checking for Windows Updates (COM)..."
    try {
        $Session = New-Object -ComObject Microsoft.Update.Session
        $Searcher = $Session.CreateUpdateSearcher()
        $Criteria = "IsInstalled=0 and Type='Software'"
        
        Write-TronLog -Level INFO -Message "Querying Windows Update Servers..."
        $SearchResult = $Searcher.Search($Criteria)
        
        if ($SearchResult.Updates.Count -eq 0) {
            Write-TronLog -Level SUCCESS -Message "Windows is up to date."
        } else {
            Write-TronLog -Level INFO -Message "Found $($SearchResult.Updates.Count) pending updates."
            
            # Auto-Install Logic check
            # Real installation via COM is complex (Download -> Install), sketching the flow:
            if ($Global:DefaultSettings.Stages.Repair.AutoUpdate) {
                # 1. Download
                $UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
                foreach ($u in $SearchResult.Updates) { $UpdatesToDownload.Add($u) | Out-Null }
                
                $Downloader = $Session.CreateUpdateDownloader()
                $Downloader.Updates = $UpdatesToDownload
                Write-TronLog -Level INFO -Message "Downloading Updates..."
                $Downloader.Download()
                
                # 2. Install
                $Installer = $Session.CreateUpdateInstaller()
                $Installer.Updates = $UpdatesToDownload
                Write-TronLog -Level INFO -Message "Installing Updates..."
                $InstallResult = $Installer.Install()
                Write-TronLog -Level SUCCESS -Message "Update Installation Complete."
            }
        }
    } catch {
        Write-TronLog -Level WARN -Message "Windows Update failed: $_"
    }
}


# --- STAGE: 05_optimize.ps1 ---
function Invoke-Stage05_Optimize {
    Write-TronLog -Level INFO -Message "Stage 5: Optimize - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would optimize (Defrag/Trim) all drives."; return }

    # 1. Ensure Defrag Service is enabled
    try {
        $svc = Get-Service "defragsvc"
        if ($svc.Status -ne "Running") {
            Set-Service "defragsvc" -StartupType Manual
            Start-Service "defragsvc"
        }
    } catch {
        Write-TronLog -Level DEBUG -Message "Could not query defragsvc: $_"
    }

    # 2. Optimize Volume (Native, Media-Aware)
    Write-TronLog -Level INFO -Message "Optimizing Storage Volumes..."
    try {
        # Get all fixed drives
        $drives = Get-Volume | Where-Object { $_.DriveType -eq 'Fixed' }
        
        foreach ($d in $drives) {
             Write-TronLog -Level INFO -Message "Optimizing Drive $($d.DriveLetter)..."
             try {
                # Optimize-Volume handles ReTrim (SSD) vs Defrag (HDD) automatically
                Optimize-Volume -DriveLetter $d.DriveLetter -Verbose -ErrorAction Stop
                Write-TronLog -Level SUCCESS -Message "Optimization Complete for $($d.DriveLetter):"
             } catch {
                Write-TronLog -Level WARN -Message "Failed to optimize $($d.DriveLetter): $_"
             }
        }
    } catch {
        Write-TronLog -Level ERROR -Message "Critical Optimization Failure: $_"
    }
}


# --- CONTROLLER ---
# --- MAIN CONTROLLER ---

# Global DryRun Override
if ($DryRun) { 
    $Global:DryRun = $true
    Write-Host ">>> DRY RUN MODE ENABLED <<<" -ForegroundColor Cyan
}

# 1. Check Elevation
Assert-Elevation

# 2. Init Logging
Initialize-TronLogging -Path $Global:DefaultSettings.LogPath
Write-TronLog -Level INFO -Message "Tron Started. Version 2.0"

# 3. Stage Execution Loop
$Stages = Get-Command -CommandType Function | Where-Object { $_.Name -like "Invoke-Stage*" } | Sort-Object Name

foreach ($stage in $Stages) {
    $stageName = $stage.Name -replace "Invoke-Stage",""
    Write-TronLog -Level INFO -Message "Starting Stage: $stageName"
    
    try {
        & $stage.Name
    } catch {
        Write-TronLog -Level ERROR -Message "Stage $stageName Failed: $_"
    }
}

Write-TronLog -Level SUCCESS -Message "Tron Execution Complete."


