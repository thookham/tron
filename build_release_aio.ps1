<#
.SYNOPSIS
    Tron All-In-One (AIO) Release Package Builder
    
.DESCRIPTION
    Creates offline-capable Tron packages with all binary tools pre-bundled.
    Supports full AIO mode (all tools) or user-selectable tool inclusion.
    
.PARAMETER Version
    Override the version number (default: reads from initialize_environment.bat)
    
.PARAMETER ReleaseDate
    Override the release date (default: today's date)
    
.PARAMETER ToolSelection
    Tool inclusion mode:
    - "Full" (default): Include all tools (~327MB without Snappy, ~2.5GB with)
    - "Essential": Include only critical tools (~150MB)
    - "Interactive": Prompt user to select which stages to include
    - "NoDrivers": Full package minus Snappy Driver Installer (~327MB)
    
.PARAMETER IncludeDrivers
    Include Snappy Driver Installer (adds ~2GB)
    
.EXAMPLE
    .\build_release_aio.ps1
    # Creates full AIO package without driver installer
    
.EXAMPLE
    .\build_release_aio.ps1 -ToolSelection Interactive
    # Prompts for which tools to include
    
.EXAMPLE
    .\build_release_aio.ps1 -IncludeDrivers
    # Creates full AIO with Snappy Driver Installer included
#>

param(
    [string]$Version = "13.2.0",
    [string]$ReleaseDate = "2025-11-29",
    [ValidateSet("Full", "Essential", "Interactive", "NoDrivers")]
    [string]$ToolSelection = "NoDrivers",
    [switch]$IncludeDrivers
)

$OutputDir = Join-Path $PSScriptRoot "releases"
$TempDir = Join-Path $env:TEMP "tron_aio_build"
$ToolsDir = Join-Path $TempDir "tools"

# Source files to include in package
$SourceFiles = @("tron.bat", "resources", "README.md", "LICENSE", "changelog.txt")

# Tool definitions with download URLs
$ToolManifest = @{
    "Stage0" = @(
        @{
            Name = "rkill"
            Version = "2.9.1.0"
            Files = @("rkill.exe", "rkill64.exe")
            URLs = @(
                "https://download.bleepingcomputer.com/grinler/rkill.com",
                "https://download.bleepingcomputer.com/grinler/rkill64.com"
            )
            TargetPath = "resources\stage_0_prep\rkill"
            Essential = $true
        },
        @{
            Name = "TDSS Killer"
            Version = "3.1.0.12"
            Files = @("TDSSKiller.exe")
            URLs = @("https://media.kaspersky.com/utilities/VirusUtilities/EN/tdsskiller.exe")
            TargetPath = "resources\stage_0_prep\tdss_killer"
            Essential = $true
        },
        @{
            Name = "Trellix Stinger"
            Version = "13.0.0.254"
            Files = @("stinger64.exe")
            URLs = @("https://downloadcenter.trellix.com/products/mcafee_avert/Stinger/stinger64.exe")
            TargetPath = "resources\stage_0_prep\stinger"
            Essential = $false
        }
    )
    
    "Stage1" = @(
        @{
            Name = "CCleaner"
            Version = "6.24"
            Files = @("CCleaner.exe")
            URLs = @("https://download.ccleaner.com/ccsetup624.exe")
            TargetPath = "resources\stage_1_tempclean\ccleaner"
            Essential = $true
            Note = "May require manual download due to version changes"
        },
        @{
            Name = "BleachBit"
            Version = "4.6.0"
            Files = @("bleachbit_console.exe")
            URLs = @("https://download.bleachbit.org/BleachBit-4.6.0-portable.zip")
            TargetPath =" resources\stage_1_tempclean\bleachbit"
            Essential = $false
        }
    )
    
    "Stage3" = @(
        @{
            Name = "AdwCleaner"
            Version = "8.4.2"
            Files = @("adwcleaner.exe")
            URLs = @("https://adwcleaner.malwarebytes.com/adwcleaner?channel=release")
            TargetPath = "resources\stage_3_disinfect\adwcleaner"
            Essential = $true
        },
        @{
            Name = "Kaspersky KVRT"
            Version = "20.0.12.0"
            Files = @("KVRT.exe")
            URLs = @("https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe")
            TargetPath = "resources\stage_3_disinfect\kaspersky_virus_removal_tool"
            Essential = $true
        },
        @{
            Name = "Malwarebytes"
            Version = "3.6.1"
            Files = @("mbam-setup.exe")
            URLs = @("https://downloads.malwarebytes.com/file/mb3-setup-consumer")
            TargetPath = "resources\stage_3_disinfect\mbam"
            Essential = $false
        }
    )
    
    "Stage4" = @(
        @{
            Name = "Spybot Anti-Beacon"
            Version = "1.7.0.47"
            Files = @("SpybotAntiBeacon.exe")
            URLs = @("https://downloads.spybot.info/AntiBeacon/SpybotAntiBeacon-1.7.exe")
            TargetPath = "resources\stage_4_repair\spybot_anti-beacon"
            Essential = $false
        },
        @{
            Name = "O&O ShutUp10"
            Version = "1.9.1442"
            Files = @("OOSU10.exe")
            URLs = @("https://dl5.oo-software.com/files/ooshutup10/OOSU10.exe")
            TargetPath = "resources\stage_4_repair\ooshutup10"
            Essential = $true
        }
    )
    
    "Stage5" = @(
        @{
            Name = "7-Zip"
            Version = "24.09"
            Files = @("7z2409-x64.exe")
            URLs = @("https://www.7-zip.org/a/7z2409-x64.exe")
            TargetPath = "resources\stage_5_patch\7-zip"
            Essential = $true
        }
    )
    
    "Stage6" = @(
        @{
            Name = "Defraggler"
            Version = "2.22.995"
            Files = @("dfsetup222.exe")
            URLs = @("https://download.ccleaner.com/dfsetup222.exe")
            TargetPath = "resources\stage_6_optimize\defrag"
            Essential = $false
        }
    )
    
    "Stage9" = @(
        @{
            Name = "Autoruns"
            Version = "14.11"
            Files = @("Autoruns.exe", "Autoruns64.exe")
            URLs = @("https://download.sysinternals.com/files/Autoruns.zip")
            TargetPath = "resources\stage_9_manual_tools\autoruns"
            Essential = $false
            RequiresExtraction = $true
        },
        @{
            Name = "Snappy Driver Installer"
            Version = "R2309"
            Files = @("SDI_R2309.exe")
            URLs = @("https://sdi-tool.org/releases/SDI_R2309.exe")
            TargetPath = "resources\stage_9_manual_tools\snappy_driver_installer"
            Essential = $false
            Size = "~2GB"
            IncludeByDefault = $false
        }
    )
}

function Write-ColorOutput {
    param([string]$Message, [ConsoleColor]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Test-InternetConnection {
    try {
        $null = Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet
        return $true
    } catch {
        return $false
    }
}

function Download-Tool {
    param(
        [hashtable]$Tool,
        [string]$DestinationPath
    )
    
    $success = $true
    
    for ($i = 0; $i -lt $Tool.URLs.Count; $i++) {
        $url = $Tool.URLs[$i]
        $file = $Tool.Files[$i]
        $dest = Join-Path $DestinationPath $file
        
        # Create directory if it doesn't exist
        $destDir = Split-Path $dest -Parent
        if (!(Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        Write-ColorOutput "  Downloading $file..." -Color Cyan
        
        try {
            # Use Invoke-WebRequest with progress
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -TimeoutSec 300
            
            if (Test-Path $dest) {
                $size = (Get-Item $dest).Length / 1MB
                Write-ColorOutput "    ✓ Downloaded ($([math]::Round($size, 2)) MB)" -Color Green
            } else {
                Write-ColorOutput "    ✗ Download failed" -Color Red
                $success = $false
            }
        } catch {
            Write-ColorOutput "    ✗ Error: $($_.Exception.Message)" -Color Red
            $success = $false
        }
    }
    
    return $success
}

function Get-UserToolSelection {
    Write-ColorOutput "`n=== Interactive Tool Selection ===" -Color Yellow
    Write-ColorOutput "Select which stages to include tools for:`n"
    
    $selections = @{}
    
    foreach ($stage in $ToolManifest.Keys | Sort-Object) {
        $count = $ToolManifest[$stage].Count
        Write-Host "$stage ($count tools)" -ForegroundColor Cyan
        
        foreach ($tool in $ToolManifest[$stage]) {
            $essentialTag = if ($tool.Essential) { " [Essential]" } else { "" }
            $sizeTag = if ($tool.Size) { " ($($tool.Size))" } else { "" }
            
            Write-Host "  - $($tool.Name) v$($tool.Version)$essentialTag$sizeTag"
        }
        
        $response = Read-Host "`nInclude $stage tools? (Y/N/E for Essential only)"
        
        switch ($response.ToUpper()) {
            "Y" { $selections[$stage] = "All" }
            "E" { $selections[$stage] = "Essential" }
            default { $selections[$stage] = "None" }
        }
        
        Write-Host ""
    }
    
    return $selections
}

function Build-AIOPackage {
    Write-ColorOutput "`n╔════════════════════════════════════════════════╗" -Color Cyan
    Write-ColorOutput "║   Tron AIO Package Builder v$Version         ║" -Color Cyan
    Write-ColorOutput "╚════════════════════════════════════════════════╝`n" -Color Cyan
    
    # Check internet connection
    if (!(Test-InternetConnection)) {
        Write-ColorOutput "⚠ Warning: No internet connection detected!" -Color Yellow
        Write-ColorOutput "AIO build requires internet to download tools.`n" -Color Yellow
        $continue = Read-Host "Continue anyway? (Y/N)"
        if ($continue -ne "Y") { exit 1 }
    }
    
    # Create directories
    if (!(Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
    }
    
    if (Test-Path $TempDir) {
        Remove-Item $TempDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
    New-Item -ItemType Directory -Path $ToolsDir -Force | Out-Null
    
    # Determine which tools to include
    $tool sToInclude = @{}
    
    switch ($ToolSelection) {
        "Full" {
            foreach ($stage in $ToolManifest.Keys) {
                $toolsToInclude[$stage] = "All"
            }
        }
        "Essential" {
            foreach ($stage in $ToolManifest.Keys) {
                $toolsToInclude[$stage] = "Essential"
            }
        }
        "NoDrivers" {
            foreach ($stage in $ToolManifest.Keys) {
                $toolsToInclude[$stage] = "All"
            }
            # Will filter out Snappy later
        }
        "Interactive" {
            $toolsToInclude = Get-UserToolSelection
        }
    }
    
    # Download tools
    Write-ColorOutput "`n📥 Downloading Tools..." -Color Yellow
    Write-ColorOutput "════════════════════════════════════════════════`n" -Color Yellow
    
    $downloadedTools = 0
    $failedTools = 0
    $skippedTools = 0
    
    foreach ($stage in $ToolManifest.Keys | Sort-Object) {
        $inclusion = $toolsToInclude[$stage]
        
        if ($inclusion -eq "None") {
            Write-ColorOutput "⊘ Skipping $stage (user selection)" -Color Gray
            continue
        }
        
        Write-ColorOutput "`n[$stage]" -Color Magenta
        
        foreach ($tool in $ToolManifest[$stage]) {
            # Skip Snappy Driver Installer unless explicitly requested
            if ($tool.Name -eq "Snappy Driver Installer" -and !$IncludeDrivers) {
                Write-ColorOutput "  ⊘ Skipping $($tool.Name) (use -IncludeDrivers to include)" -Color Gray
                $skippedTools++
                continue
            }
            
            # Skip non-essential if in Essential mode
            if ($inclusion -eq "Essential" -and !$tool.Essential) {
                Write-ColorOutput "  ⊘ Skipping $($tool.Name) (non-essential)" -Color Gray
                $skippedTools++
                continue
            }
            
            Write-ColorOutput "`n  $($tool.Name) v$($tool.Version)" -Color White
            
            $targetPath = Join-Path $TempDir $tool.TargetPath
            
            if (Download-Tool -Tool $tool -DestinationPath $targetPath) {
                $downloadedTools++
            } else {
                $failedTools++
                
                if ($tool.Note) {
                    Write-ColorOutput "    ℹ $($tool.Note)" -Color Yellow
                }
            }
        }
    }
    
    # Copy source files
    Write-ColorOutput "`n`n📦 Packaging Files..." -Color Yellow
    Write-ColorOutput "════════════════════════════════════════════════`n" -Color Yellow
    
    foreach ($file in $SourceFiles) {
        $source = Join-Path $PSScriptRoot $file
        $dest = Join-Path $TempDir $file
        
        if (Test-Path $source) {
            Write-ColorOutput "  Copying $file..." -Color Cyan
            
            if ((Get-Item $source).PSIsContainer) {
                # It's a directory
                Copy-Item $source $dest -Recurse -Force
            } else {
                # It's a file
                Copy-Item $source $dest -Force
            }
        }
    }
    
    # Merge downloaded tools into package
    Write-ColorOutput "`n  Merging downloaded tools into package..." -Color Cyan
    Get-ChildItem $ToolsDir -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($ToolsDir.Length + 1)
        $dest = Join-Path $TempDir $relativePath
        
        $destDir = Split-Path $dest -Parent
        if (!(Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        Copy-Item $_.FullName $dest -Force
    }
    
    # Create AIO indicator file
    $aioMarker = Join-Path $TempDir "resources\.tron_aio_package"
    @"
This is a Tron All-In-One (AIO) package
Version: $Version
Built: $ReleaseDate
Tool Selection: $ToolSelection
Includes Drivers: $IncludeDrivers

This package includes pre-downloaded binary tools and can run offline.
"@ | Out-File $aioMarker -Encoding ASCII
    
    # Build ZIP package
    Write-ColorOutput "`n`n🗜️  Creating ZIP Archive..." -Color Yellow
    Write-ColorOutput "════════════════════════════════════════════════`n" -Color Yellow
    
    $zipName = "tron_v${Version}_aio.zip"
    $zipPath = Join-Path $OutputDir $zipName
    
    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }
    
    Write-ColorOutput "  Compressing files..." -Color Cyan
    Compress-Archive -Path (Join-Path $TempDir "*") -DestinationPath $zipPath -CompressionLevel Optimal
    
    $zipSize = (Get-Item $zipPath).Length / 1MB
    Write-ColorOutput "  ✓ ZIP created: $zipName ($([math]::Round($zipSize, 2)) MB)" -Color Green
    
    # Build SFX EXE package (using 7-Zip if available)
    Write-ColorOutput "`n`n📦 Creating SFX EXE Package..." -Color Yellow
    Write-ColorOutput "════════════════════════════════════════════════`n" -Color Yellow
    
    $exeName = "tron_v${Version}_aio.exe"
    $exePath = Join-Path $OutputDir $exeName
    
    $sevenZipPaths = @(
        "C:\Program Files\7-Zip\7z.exe",
        "C:\Program Files (x86)\7-Zip\7z.exe",
        (Join-Path $env:ProgramFiles "7-Zip\7z.exe")
    )
    
    $sevenZip = $sevenZipPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
    
    if ($sevenZip) {
        Write-ColorOutput "  Using 7-Zip: $sevenZip" -Color Cyan
        
        # Create SFX config
        $sfxConfig = Join-Path $TempDir "sfx_config.txt"
        @"
;!@Install@!UTF-8!
Title="Tron v$Version AIO"
BeginPrompt="Tron v$Version All-In-One Package`n`nThis will extract Tron to the current directory."
;!@InstallEnd@!
"@ | Out-File $sfxConfig -Encoding ASCII
        
        # Find SFX module
        $sfxModule = Join-Path (Split-Path $sevenZip) "7zSD.sfx"
        
        if (!(Test-Path $sfxModule)) {
            Write-ColorOutput "  ⚠ SFX module not found, using default..." -Color Yellow
            $sfxModule = Join-Path (Split-Path $sevenZip) "7zS.sfx"
        }
        
        # Create temporary 7z archive
        $temp7z = Join-Path $TempDir "temp.7z"
        & $sevenZip a -t7z -mx=9 $temp7z (Join-Path $TempDir "*") | Out-Null
        
        # Combine SFX module + config + archive
        if (Test-Path $sfxModule) {
            Get-Content $sfxModule -Encoding Byte -ReadCount 0 | Set-Content $exePath -Encoding Byte
            Get-Content $sfxConfig -Encoding Byte -ReadCount 0 | Add-Content $exePath -Encoding Byte
            Get-Content $temp7z -Encoding Byte -ReadCount 0 | Add-Content $exePath -Encoding Byte
            
            $exeSize = (Get-Item $exePath).Length / 1MB
            Write-ColorOutput "  ✓ SFX EXE created: $exeName ($([math]::Round($exeSize, 2)) MB)" -Color Green
        } else {
            Write-ColorOutput "  ✗ SFX module not found, EXE creation skipped" -Color Yellow
        }
        
        Remove-Item $temp7z -ErrorAction SilentlyContinue
    } else {
        Write-ColorOutput "  ⚠ 7-Zip not found, skipping EXE creation" -Color Yellow
        Write-ColorOutput "    Install 7-Zip to enable SFX EXE packaging" -Color Gray
    }
    
    # Cleanup
    Write-ColorOutput "`n`n🧹 Cleaning Up..." -Color Yellow
    Write-ColorOutput "════════════════════════════════════════════════`n" -Color Yellow
    
    Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-ColorOutput "  ✓ Temporary files removed" -Color Green
    
    # Summary
    Write-ColorOutput "`n`n╔════════════════════════════════════════════════╗" -Color Green
    Write-ColorOutput "║             Build Complete! ✓                  ║" -Color Green
    Write-ColorOutput "╚════════════════════════════════════════════════╝`n" -Color Green
    
    Write-ColorOutput "📊 Summary:" -Color Cyan
    Write-ColorOutput "  • Tools Downloaded: $downloadedTools" -Color White
    Write-ColorOutput "  • Tools Skipped: $skippedTools" -Color Gray
    Write-ColorOutput "  • Tools Failed: $failedTools" -Color $(if ($failedTools -gt 0) { "Yellow" } else { "White" })
    Write-ColorOutput "`n📁 Output Directory:" -Color Cyan
    Write-ColorOutput "  $OutputDir`n" -Color White
    
    if ($failedTools -gt 0) {
        Write-ColorOutput "⚠ Some tools failed to download. Review the log above." -Color Yellow
        Write-ColorOutput "   The package may have reduced functionality.`n" -Color Yellow
    }
    
    # Open output directory
    Start-Process explorer.exe $OutputDir
}

# Execute build
Build-AIOPackage
