# fetch_tools.ps1
# Downloads missing third-party tools for Tron

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ResourcesPath = Join-Path $PSScriptRoot ".."

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

Write-Host "Checking for missing tools..." -ForegroundColor Cyan

foreach ($Tool in $Tools) {
    if (-not (Test-Path $Tool.DestDir)) {
        New-Item -ItemType Directory -Path $Tool.DestDir -Force | Out-Null
    }

    $DestPath = Join-Path $Tool.DestDir $Tool.FileName

    if (-not (Test-Path $DestPath)) {
        Write-Host "Downloading $($Tool.Name)..." -ForegroundColor Yellow
        try {
            Invoke-WebRequest -Uri $Tool.Url -OutFile $DestPath -UserAgent "Tron-Downloader"
            Write-Host "  Done." -ForegroundColor Green
        }
        catch {
            Write-Host "  Failed to download $($Tool.Name): $_" -ForegroundColor Red
        }
    }
    else {
        Write-Host "$($Tool.Name) already exists." -ForegroundColor Gray
    }
}

Write-Host "Tool check complete." -ForegroundColor Cyan
