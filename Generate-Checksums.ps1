<#
.SYNOPSIS
    Generates SHA256 checksums for files in a directory.
.DESCRIPTION
    Scans the specified directory for .zip and .exe files, calculates their SHA256 hashes,
    and outputs them to a 'sha256sums.txt' file in the same directory.
.PARAMETER Path
    The directory containing the files to hash.
.EXAMPLE
    .\Generate-Checksums.ps1 -Path ".\releases"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

if (-not (Test-Path $Path)) {
    Write-Error "Directory not found: $Path"
    exit 1
}

$OutputFile = Join-Path $Path "sha256sums.txt"
$Files = Get-ChildItem -Path "$Path\*" -Include *.zip, *.exe -File

if ($Files.Count -eq 0) {
    Write-Warning "No .zip or .exe files found in $Path"
    exit 0
}

Write-Host "Generating checksums for $($Files.Count) files in $Path..." -ForegroundColor Cyan

$Checksums = @()

foreach ($File in $Files) {
    Write-Host "  Hashing $($File.Name)..." -NoNewline
    $Hash = Get-FileHash -Path $File.FullName -Algorithm SHA256
    $Entry = "$($Hash.Hash.ToLower())  $($File.Name)"
    $Checksums += $Entry
    Write-Host " Done." -ForegroundColor Green
}

Set-Content -Path $OutputFile -Value $Checksums -Encoding UTF8
Write-Host "Checksums saved to $OutputFile" -ForegroundColor Green
