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
