function Invoke-Stage04_Repair {
    Write-TronLog -Level INFO -Message "Stage 4: Repair - Initializing..."
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would run SFC, DISM, and Windows Update."; return }

    # 1. Self-Healing System Repair Loop
    Write-TronLog -Level INFO -Message "Starting SFC Scan..."
    $sfcArgs = "/scannow"
    $sfcProc = Start-Process -FilePath "sfc.exe" -ArgumentList $sfcArgs -Wait -NoNewWindow -PassThru
    
    if ($sfcProc.ExitCode -ne 0) {
        Write-TronLog -Level WARN -Message "SFC found corruption (Exit Code: $($sfcProc.ExitCode)). Attempting DISM Repair..."
        
        # Run DISM RestoreHealth
        $dismArgs = "/Online /Cleanup-Image /RestoreHealth"
        Start-Process -FilePath "dism.exe" -ArgumentList $dismArgs -Wait -NoNewWindow
        
        # Re-verify with SFC
        Write-TronLog -Level INFO -Message "Verifying repairs with second SFC scan..."
        Start-Process -FilePath "sfc.exe" -ArgumentList $sfcArgs -Wait -NoNewWindow
    } else {
        Write-TronLog -Level SUCCESS -Message "SFC: No integrity violations found."
    }

    # 2. Windows Update via COM (Native, No Module)
    Write-TronLog -Level INFO -Message "Checking for Windows Updates (COM)..."
    try {
        $Session = New-Object -ComObject Microsoft.Update.Session
        $Searcher = $Session.CreateUpdateSearcher()
        $Criteria = "IsInstalled=0 and Type='Software'"
        
        Write-TronLog -Level INFO -Message "Querying Windows Update Servers..."
        $SearchResult = $Searcher.Search($Criteria)
        
        if ($SearchResult.Updates.Count -eq 0) {
            Write-TronLog -Level SUCCESS -Message "Windows is up to date."
        } else {
            Write-TronLog -Level INFO -Message "Found $($SearchResult.Updates.Count) pending updates."
            
            # Auto-Install Logic check
            # Real installation via COM is complex (Download -> Install), sketching the flow:
            if ($Global:DefaultSettings.Stages.Repair.AutoUpdate) {
                # 1. Download
                $UpdatesToDownload = New-Object -ComObject Microsoft.Update.UpdateColl
                foreach ($u in $SearchResult.Updates) { $UpdatesToDownload.Add($u) | Out-Null }
                
                $Downloader = $Session.CreateUpdateDownloader()
                $Downloader.Updates = $UpdatesToDownload
                Write-TronLog -Level INFO -Message "Downloading Updates..."
                $Downloader.Download()
                
                # 2. Install
                $Installer = $Session.CreateUpdateInstaller()
                $Installer.Updates = $UpdatesToDownload
                Write-TronLog -Level INFO -Message "Installing Updates..."
                $InstallResult = $Installer.Install()
                Write-TronLog -Level SUCCESS -Message "Update Installation Complete."
            }
        }
    } catch {
        Write-TronLog -Level WARN -Message "Windows Update failed: $_"
    }
}
