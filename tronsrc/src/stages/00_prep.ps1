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
