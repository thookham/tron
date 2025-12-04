<#
.SYNOPSIS
    Updates the Tron version and date across all relevant files.
.DESCRIPTION
    Updates the version string and release date in:
    - resources\functions\initialize_environment.bat (TRON_VERSION, TRON_DATE)
    - tron.bat (SCRIPT_VERSION, SCRIPT_DATE)
    - build_release.ps1 ($Version, $ReleaseDate)
    - README.md (Badge/Text if found)
.PARAMETER Version
    The new version string (e.g., "12.0.8").
.PARAMETER Date
    The release date (YYYY-MM-DD). Defaults to current date.
.EXAMPLE
    .\Update-TronVersion.ps1 -Version "12.0.8"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$Date = (Get-Date -Format "yyyy-MM-dd")
)

$Root = $PSScriptRoot
$InitEnvPath = Join-Path $Root "resources\functions\initialize_environment.bat"
$TronBatPath = Join-Path $Root "tron.bat"
$BuildScriptPath = Join-Path $Root "build_release.ps1"
$ReadmePath = Join-Path $Root "README.md"

Write-Host "Updating Tron to v$Version ($Date)..." -ForegroundColor Cyan

# 1. Update initialize_environment.bat
if (Test-Path $InitEnvPath) {
    Write-Host "Updating $InitEnvPath..." -NoNewline
    $content = Get-Content $InitEnvPath -Raw
    $content = $content -replace 'set TRON_VERSION=.*', "set TRON_VERSION=$Version"
    $content = $content -replace 'set TRON_DATE=.*', "set TRON_DATE=$Date"
    Set-Content -Path $InitEnvPath -Value $content -Encoding ASCII
    Write-Host " Done." -ForegroundColor Green
}
else {
    Write-Warning "File not found: $InitEnvPath"
}

# 2. Update tron.bat
if (Test-Path $TronBatPath) {
    Write-Host "Updating $TronBatPath..." -NoNewline
    $content = Get-Content $TronBatPath -Raw
    $content = $content -replace 'set SCRIPT_VERSION=.*', "set SCRIPT_VERSION=$Version"
    $content = $content -replace 'set SCRIPT_DATE=.*', "set SCRIPT_DATE=$Date"
    Set-Content -Path $TronBatPath -Value $content -Encoding ASCII
    Write-Host " Done." -ForegroundColor Green
}
else {
    Write-Warning "File not found: $TronBatPath"
}

# 3. Update build_release.ps1
if (Test-Path $BuildScriptPath) {
    Write-Host "Updating $BuildScriptPath..." -NoNewline
    $content = Get-Content $BuildScriptPath -Raw
    $content = $content -replace '\$Version = ".*"', "`$Version = `"$Version`""
    $content = $content -replace '\$ReleaseDate = ".*"', "`$ReleaseDate = `"$Date`""
    Set-Content -Path $BuildScriptPath -Value $content -Encoding UTF8
    Write-Host " Done." -ForegroundColor Green
}
else {
    Write-Warning "File not found: $BuildScriptPath"
}

# 4. Update README.md (Optional - looks for specific patterns)
if (Test-Path $ReadmePath) {
    Write-Host "Updating $ReadmePath..." -NoNewline
    $content = Get-Content $ReadmePath -Raw
    # Example pattern: "Current Version: **12.0.7**" or similar. 
    # Adjust regex based on actual README content if needed.
    # For now, we'll try a generic "vX.X.X" replacement if it appears in a header context
    
    # This is a best-effort update for README
    if ($content -match "Tron v\d+\.\d+\.\d+") {
        $content = $content -replace "Tron v\d+\.\d+\.\d+", "Tron v$Version"
        Set-Content -Path $ReadmePath -Value $content -Encoding UTF8
        Write-Host " Done." -ForegroundColor Green
    }
    else {
        Write-Host " Skipped (Pattern not found)." -ForegroundColor Gray
    }
}

Write-Host "Version update complete." -ForegroundColor Cyan
