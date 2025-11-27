@echo off
:: Purpose: Wait for N seconds (XP compatible)
:: Usage:   call wait.bat SECONDS

set "SECONDS=%~1"
if "%SECONDS%"=="" set SECONDS=5

:: Check for timeout command (Vista+)
timeout /? >nul 2>&1
if %errorlevel% equ 0 (
    timeout /t %SECONDS% /nobreak >nul
) else (
    :: XP Fallback: Ping
    :: Ping waits 1 second between pings, so we need N+1 pings
    set /a PINGS=%SECONDS%+1
    ping 127.0.0.1 -n %PINGS% >nul
)
exit /b 0
