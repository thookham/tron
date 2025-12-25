function Invoke-Stage02_Debloat {
    Write-TronLog -Level INFO -Message "Stage 2: Debloat - Initializing..."
    
    if ($Global:DryRun) { Write-TronLog -Level INFO -Message "[DRY RUN] Would remove Appx Packages not in allowlist."; return }

    # 1. Load AllowList
    if (-not $Global:AllowLists.ProtectedApps) {
        Write-TronLog -Level WARN -Message "No AllowList found! Aborting Debloat to prevent system damage."
        return
    }
    $Allowed = $Global:AllowLists.ProtectedApps

    # 2. Debloat Provisioned Packages (System-wide)
    Write-TronLog -Level INFO -Message "Scanning Provisioned Packages..."
    $Provisioned = Get-AppxProvisionedPackage -Online
    
    foreach ($App in $Provisioned) {
        if ($App.DisplayName -notin $Allowed) {
            Write-TronLog -Level INFO -Message "Removing Provisioned App: $($App.DisplayName)..."
            try {
                Remove-AppxProvisionedPackage -Online -PackageName $App.PackageName -ErrorAction Stop | Out-Null
            } catch {
                Write-TronLog -Level DEBUG -Message "Failed to remove $($App.DisplayName): $_"
            }
        }
    }

    # 3. Debloat Installed Packages (Current User)
    Write-TronLog -Level INFO -Message "Scanning User Packages..."
    $UserApps = Get-AppxPackage -PackageTypeFilter Main
    
    foreach ($App in $UserApps) {
        # Check against simple name (e.g. Microsoft.WindowsCalculator)
        if ($App.Name -notin $Allowed -and $App.Values.NonRemovable -ne $true) {
             Write-TronLog -Level INFO -Message "Removing User App: $($App.Name)..."
             try {
                Remove-AppxPackage -Package $App.PackageFullName -ErrorAction Stop
             } catch {
                Write-TronLog -Level DEBUG -Message "Failed to remove $($App.Name): $_"
             }
        }
    }

    Write-TronLog -Level SUCCESS -Message "Debloat Complete."
}
