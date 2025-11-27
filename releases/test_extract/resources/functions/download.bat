@echo off
:: Purpose: Download a file using PowerShell (Modern) or VBScript (Legacy/XP)
:: Usage:   call download.bat "URL" "OUTPUT_PATH"

set "URL=%~1"
set "OUTPUT=%~2"

:: Check for PowerShell
powershell -command "exit" >nul 2>&1
if %errorlevel% equ 0 (
    :: Modern: Use PowerShell
    powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%URL%' -OutFile '%OUTPUT%' -UserAgent 'Tron-Downloader' -ErrorAction Stop"
    exit /b %errorlevel%
)

:: Legacy: Use VBScript (Windows XP/Vista/7 without PS)
echo Downloading via VBScript (Legacy Mode)...
set "VBS_FILE=%TEMP%\download_%RANDOM%.vbs"

(
echo Dim xHttp: Set xHttp = CreateObject("Microsoft.XMLHTTP"^)
echo Dim bStrm: Set bStrm = CreateObject("Adodb.Stream"^)
echo xHttp.Open "GET", "%URL%", False
echo xHttp.Send
echo with bStrm
echo     .type = 1
echo     .open
echo     .write xHttp.responseBody
echo     .savetofile "%OUTPUT%", 2
echo end with
) > "%VBS_FILE%"

cscript //nologo "%VBS_FILE%"
set "DL_ERROR=%errorlevel%"
del "%VBS_FILE%"
exit /b %DL_ERROR%
