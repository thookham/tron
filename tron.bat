@echo off
setlocal
title Tron (Legacy Fallback)
echo ===============================================================================
echo   Tron v2.0 (Legacy Fallback Launcher)
echo   Windows System Maintenance & Repair
echo ===============================================================================

:: 1. TRY POWERSHELL EXECUTION (Preferred)
echo [INFO] Attempting to launch modern Tron (PowerShell)...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0tron.ps1"
if %ERRORLEVEL% EQU 0 (
    echo [SUCCESS] PowerShell Tron completed successfully.
    goto :EOF
)

:: 2. FALLBACK EXECUTION (If PowerShell fails)
echo.
echo [WARN] PowerShell execution failed or was not found.
echo [WARN] Falling back to LEGACY BATCH MODE.
echo.
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo !  NOTE: This legacy mode is "Best Effort" only.                               !
echo !  Some advanced features (Debloat, Intelligent Repair) are unavailable.      !
echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo.
timeout /t 5

:: Stage 0: Prep
echo.
echo [STAGE 0] PREP
echo -------------------------------------------------------------------------------
echo [INFO] Attempting to create Restore Point (vssadmin)...
vssadmin create shadow /for=C: >nul 2>&1
if %ERRORLEVEL% NEQ 0 echo [WARN] Failed to create Shadow Copy.

echo [INFO] Checking SMART Status (wmic)...
wmic diskdrive get status
echo -------------------------------------------------------------------------------

:: Stage 1: TempClean
echo.
echo [STAGE 1] TEMPCLEAN
echo -------------------------------------------------------------------------------
echo [INFO] Cleaning Temp Files...
del /F /S /Q "%TEMP%\*.*" >nul 2>&1
del /F /S /Q "%WINDIR%\Temp\*.*" >nul 2>&1
echo [INFO] Clearing Event Logs...
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :ClearLog "%%G")
goto :SkipLogFunc
:ClearLog
wevtutil.exe cl "%1" >nul 2>&1
goto :eof
:SkipLogFunc
echo -------------------------------------------------------------------------------

:: Stage 3: Disinfect
echo.
echo [STAGE 3] DISINFECT
echo -------------------------------------------------------------------------------
echo [INFO] Running Windows Defender Scan (MpCmdRun)...
if exist "%ProgramFiles%\Windows Defender\MpCmdRun.exe" (
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -SignatureUpdate
    "%ProgramFiles%\Windows Defender\MpCmdRun.exe" -Scan -ScanType 1
) else (
    echo [WARN] Defender CLI not found.
)
echo -------------------------------------------------------------------------------

:: Stage 4: Repair
echo.
echo [STAGE 4] REPAIR
echo -------------------------------------------------------------------------------
echo [INFO] Running SFC /scannow...
sfc /scannow
echo [INFO] Running DISM RestoreHealth...
dism /Online /Cleanup-Image /RestoreHealth
echo -------------------------------------------------------------------------------

:: Stage 5: Optimize
echo.
echo [STAGE 5] OPTIMIZE
echo -------------------------------------------------------------------------------
echo [INFO] Optimizing C: Drive...
defrag C: /O /U /V
echo -------------------------------------------------------------------------------

echo.
echo [SUCCESS] Legacy fallback run complete.
echo Please review c:\windows\logs\cbs\cbs.log for repair details.
pause
