<# :
@echo off
:: fetch_tools.bat
:: Hybrid Batch/PowerShell script to download missing internal Tron tools.

:: This script is now a wrapper for individual tool downloads
:: For now, we'll just echo a warning that this legacy script is deprecated
echo  ! This script is deprecated. Tools are now fetched on-demand or pre-bundled.
exit /b 0
goto :eof
#>

function Invoke-FetchTools {
    $ErrorActionPreference = "Stop"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # $PSScriptRoot is empty when running via Invoke-Expression/Get-Content, so we derive path from the script file location
    # But since we are inside a function called from the hybrid header, we can't rely on $PSScriptRoot directly in the same way.
    # However, we can assume the current working directory is correct OR pass it in.
    # Tron sets CWD to \resources before calling this.
    
    # Let's use the current location as the base for resources if we are in \resources
    # Tron calls this from \resources usually.
    # Let's be robust and find the 'resources' directory.
    
    $CurrentDir = Get-Location
    $ResourcesPath = $CurrentDir.Path
    
    # If we are in 'functions', go up one level
    if ($ResourcesPath -match "functions$") {
        $ResourcesPath = Join-Path $ResourcesPath ".."
    }

    # Define tools and their destinations
    $Tools = @(
        @{
            Name     = "Malwarebytes Anti-Malware"
            Url      = "https://downloads.malwarebytes.com/file/mb4_offline"
            DestDir  = Join-Path $ResourcesPath "stage_3_disinfect\mbam"
            FileName = "mbam-setup.exe"
        },
        @{
            Name     = "AdwCleaner"
            Url      = "https://downloads.malwarebytes.com/file/adwcleaner"
            DestDir  = Join-Path $ResourcesPath "stage_3_disinfect\malwarebytes_adwcleaner"
            FileName = "adwcleaner.exe"
        },
        @{
            Name     = "Kaspersky Virus Removal Tool"
            Url      = "https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe"
            DestDir  = Join-Path $ResourcesPath "stage_3_disinfect\kaspersky_virus_removal_tool"
            FileName = "KVRT.exe"
        }
    )

    foreach ($Tool in $Tools) {
        if (-not (Test-Path $Tool.DestDir)) {
            New-Item -ItemType Directory -Path $Tool.DestDir -Force | Out-Null
        }

        $DestPath = Join-Path $Tool.DestDir $Tool.FileName

        if (-not (Test-Path $DestPath)) {
            Write-Host "Downloading $($Tool.Name)..."
            try {
                Invoke-WebRequest -Uri $Tool.Url -OutFile $DestPath -UserAgent "Tron-Downloader"
            }
            catch {
                Write-Warning "Failed to download $($Tool.Name). Error: $_"
            }
        }
    }
}
