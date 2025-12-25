function Test-IsAdmin {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]$identity
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Assert-Elevation {
    if (-not (Test-IsAdmin)) {
        Write-Warning "Tron requires Administrator privileges."
        if ($Global:NonInteractive) {
            Throw "Elevation required in NonInteractive mode."
        }
        
        # Self-Elevate
        Write-Host "Relaunching as Administrator..." -ForegroundColor Yellow
        $exe = (Get-Process -Id $PID).Path
        $args = $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { "-$($_.Key)" }
        
        Start-Process $exe -ArgumentList "-File `"$PSCommandPath`" $args" -Verb RunAs
        Exit
    }
}
