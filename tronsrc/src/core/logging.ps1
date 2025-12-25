function Initialize-TronLogging {
    param([string]$Path)
    
    $Global:TronLogPath = $Path
    $parent = Split-Path $Path -Parent
    if (-not (Test-Path $parent)) { New-Item $parent -ItemType Directory -Force | Out-Null }
    
    # Start Transcript for black-box recording
    Start-Transcript -Path "$Path.transcript.log" -Force | Out-Null
}

function Write-TronLog {
    param(
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO","WARN","ERROR","SUCCESS","DEBUG")]$Level = "INFO"
    )

    $ts = Get-Date -Format "HH:mm:ss"
    $line = "[$ts] [$Level] $Message"
    
    # Color logic
    $color = switch ($Level) {
        "INFO" { "White" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "DEBUG" { "Gray" }
    }
    
    Write-Host "[$Level] $Message" -ForegroundColor $color
    
    if ($Global:TronLogPath) {
        Add-Content -Path $Global:TronLogPath -Value $line
    }
}
