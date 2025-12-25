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
