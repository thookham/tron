<#
.SYNOPSIS
    Build Script for Tron
.DESCRIPTION
    Concatenates all source modules into a single portable 'tron.ps1' file.
    Optionally compiles a native 'tron.exe' wrapper.
#>
param(
    [string]$OutFile = "$PSScriptRoot\..\..\tron.ps1"
)

$SrcRoot = "$PSScriptRoot\..\src"
$ConfigRoot = "$PSScriptRoot\..\config"

Write-Host "Building Tron..." -ForegroundColor Cyan

# 1. Header & Parameters
$ScriptContent = @"
<#
    Tron - Automated System Maintenance
    Generated: $(Get-Date)
#>
# --- PARAMETERS ---
param(
    [switch]`$DryRun,
    [switch]`$NonInteractive,
    [switch]`$AutoReboot
)
`$ErrorActionPreference = 'Stop'

# --- EMBEDDED CONFIG ---
"@

# 2. Embed Configs
$Settings = Get-Content "$ConfigRoot\settings.json" -Raw
$AllowLists = Get-Content "$ConfigRoot\allowlists.json" -Raw

$ScriptContent += "`n`$Global:DefaultSettings = '$Settings' | ConvertFrom-Json`n"
$ScriptContent += "`n`$Global:AllowLists = '$AllowLists' | ConvertFrom-Json`n"

# 3. Append Core Modules (Logging, Elevation)
$CoreFiles = @("logging.ps1", "elevation.ps1")
foreach ($file in $CoreFiles) {
    Write-Host "Merging Core: $file"
    $Content = Get-Content "$SrcRoot\core\$file" -Raw
    $ScriptContent += "`n# --- MODULE: $file ---`n$Content`n"
}

# 4. Append Utils
$UtilFiles = Get-ChildItem "$SrcRoot\utils\*.ps1" -ErrorAction SilentlyContinue
foreach ($file in $UtilFiles) {
    Write-Host "Merging Util: $($file.Name)"
    $Content = Get-Content $file.FullName -Raw
    $ScriptContent += "`n# --- MODULE: $($file.Name) ---`n$Content`n"
}

# 5. Append Stages
$StageFiles = Get-ChildItem "$SrcRoot\stages\*.ps1" | Sort-Object Name
foreach ($file in $StageFiles) {
    Write-Host "Merging Stage: $($file.Name)"
    $Content = Get-Content $file.FullName -Raw
    $ScriptContent += "`n# --- STAGE: $($file.Name) ---`n$Content`n"
}

# 6. Append Main Execution Logic
Write-Host "Merging Main Controller"
$MainContent = Get-Content "$SrcRoot\core\main.ps1" -Raw
$ScriptContent += "`n# --- CONTROLLER ---`n$MainContent`n"

# Write Output
Set-Content -Path $OutFile -Value $ScriptContent
Write-Host "Script Build Complete: $OutFile" -ForegroundColor Green

# -------------------------------------------------------------------------
# EXE COMPILATION (Native Wrapper)
# -------------------------------------------------------------------------
Write-Host "`nGenerating Native Executable (tron.exe)..." -ForegroundColor Cyan

# Prepare C# Source
# We base64 encode the script to avoid escaping hell in C# string
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($ScriptContent)
$Base64Script = [System.Convert]::ToBase64String($Bytes)

$CSharpSource = @"
using System;
using System.Diagnostics;
using System.IO;
using System.Text;

class TronLauncher {
    static void Main(string[] args) {
        // Embedded Base64 Script
        string base64Script = "$Base64Script";
        
        string tempPath = Path.GetTempPath();
        string scriptPath = Path.Combine(tempPath, "tron_" + Guid.NewGuid().ToString().Substring(0, 8) + ".ps1");
        
        try {
            // Decode and Save
            byte[] scriptBytes = Convert.FromBase64String(base64Script);
            File.WriteAllBytes(scriptPath, scriptBytes);
            
            Console.WriteLine("[Wrapper] Launching Tron...");
            
            // Build Args
            // Pass through any args provided to the exe
            string passArgs = String.Join(" ", args);
            
            ProcessStartInfo psi = new ProcessStartInfo();
            psi.FileName = "powershell.exe";
            psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File \"" + scriptPath + "\" " + passArgs;
            psi.UseShellExecute = false;
            
            Process p = Process.Start(psi);
            p.WaitForExit();
            
        } catch (Exception ex) {
            Console.WriteLine("[Wrapper] Error: " + ex.Message);
        } finally {
            // Cleanup
            if (File.Exists(scriptPath)) {
                try { File.Delete(scriptPath); } catch { }
            }
        }
    }
}
"@

$SourceFile = "$PSScriptRoot\..\..\tron_wrapper.cs"
$ExeFile = "$PSScriptRoot\..\..\tron.exe"
Set-Content -Path $SourceFile -Value $CSharpSource

# Locate CSC.exe (C# Compiler)
$CSCPaths = @(
    "$env:windir\Microsoft.NET\Framework64\v4.0.30319\csc.exe",
    "$env:windir\Microsoft.NET\Framework\v4.0.30319\csc.exe"
)

$CSC = $null
foreach ($path in $CSCPaths) {
    if (Test-Path $path) { $CSC = $path; break }
}

if ($CSC) {
    Write-Host "Found Compiler: $CSC"
    # Compile
    $ArgList = "/target:exe /out:`"$ExeFile`" `"$SourceFile`""
    Start-Process -FilePath $CSC -ArgumentList $ArgList -Wait -NoNewWindow
    
    if (Test-Path $ExeFile) {
        Write-Host "EXE Build Complete: $ExeFile" -ForegroundColor Green
        Remove-Item $SourceFile -Force
    } else {
        Write-Host "Compilation Failed." -ForegroundColor Red
    }
} else {
    Write-Host "Warning: csc.exe not found. Skipping EXE build." -ForegroundColor Yellow
}
