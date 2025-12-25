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
