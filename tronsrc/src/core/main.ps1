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
