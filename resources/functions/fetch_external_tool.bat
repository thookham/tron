<# :
@echo off
:: fetch_external_tool.bat
:: Hybrid Batch/PowerShell script to download, run, and delete a tool.
:: Usage: fetch_external_tool.bat -Url "..." -ToolName "..." [-Args "..."]

call "%~dp0download.bat" "%URL%" "%TOOL_PATH%"
if %errorlevel% neq 0 (
    echo  ^! Download failed.
    exit /b 1
)
call "%TOOL_PATH%" %*
goto :eof
#>

function Invoke-ExternalTool {
    <#
    .SYNOPSIS
        Downloads a tool, executes it, and then removes it.
    #>
    param (
        [Parameter(Mandatory=$true)]
        [string]$Url,

        [Parameter(Mandatory=$true)]
        [string]$ToolName,

        [Parameter(Mandatory=$false)]
        [string]$Args = ""
    )

    $ErrorActionPreference = "Stop"
    $TempDir = [System.IO.Path]::GetTempPath()
    $OutputPath = Join-Path -Path $TempDir -ChildPath $ToolName

    Write-Host " [fetch_tool] Downloading $ToolName from $Url..."
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $Url -OutFile $OutputPath -UseBasicParsing
    }
    catch {
        Write-Error " [fetch_tool] Failed to download $ToolName. Error: $_"
        exit 1
    }

    if (Test-Path -Path $OutputPath) {
        Write-Host " [fetch_tool] Executing $ToolName with arguments: $Args"
        try {
            # Start-Process arguments need careful handling if they contain spaces/quotes
            if ($Args) {
                $Process = Start-Process -FilePath $OutputPath -ArgumentList $Args -Wait -PassThru -NoNewWindow
            } else {
                $Process = Start-Process -FilePath $OutputPath -Wait -PassThru -NoNewWindow
            }
            Write-Host " [fetch_tool] Execution complete. Exit code: $($Process.ExitCode)"
        }
        catch {
            Write-Error " [fetch_tool] Failed to execute $ToolName. Error: $_"
        }
        finally {
            Write-Host " [fetch_tool] Cleaning up..."
            Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue
        }
    } else {
        Write-Error " [fetch_tool] Downloaded file not found at $OutputPath"
        exit 1
    }
}
