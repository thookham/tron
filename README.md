# Tron v2.0 🛡️

**"Native-First" Automated Systems Maintenance**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows_10%2F11-blue.svg)](https://microsoft.com/windows)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()

> [!IMPORTANT]
> **This is Tron v2.0.**
> A complete rewrite of the classic TronScript, re-engineered from the ground up in PowerShell.
> It is **Fast**, **Powerful**, **Flexible**, **Portable**, and **Automatic**.

---

## 🚀 Overview

Tron v2.0 is an automated system maintenance tool for Windows. Unlike its predecessor which relied on a patchwork of external binaries and batch scripts, v2.0 leverages **native Windows capabilities** to clean, disinfect, repair, and optimize your system.

### Key Philosophy: "Native-First"
We believe the best tools for maintaining Windows are already built into Windows.
*   **No unnecessary external binaries**: Why download a 3rd party cleaner when Windows has `cleanmgr /sageset`?
*   **Security via Transparency**: The entire codebase is readable PowerShell. No black boxes.
*   **Self-Healing**: Uses native SFC (System File Checker) and DISM to repair corruption automatically.

---

## 📦 Download & Run

Tron is distributed as a **single portable executable** (or script).

### Method 1: Portable EXE (Recommended)
1.  Download `tron.exe`.
2.  Right-click and **Run as Administrator**.
3.  Tron will handle the rest.

### Method 2: PowerShell Script
1.  Download `tron.ps1`.
2.  Open an Administrator PowerShell terminal.
3.  Run:
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\tron.ps1
    ```

### Method 3: Legacy Fallback (Broken Systems)
If PowerShell is damaged or unavailable, use `tron.bat`. It will attempt to launch the modern script, but fall back to a "Best Effort" mode using raw native commands (`sfc`, `dism`, `vssadmin`).

---

## ⚙️ How It Works (The Stages)

Tron executes a series of "Stages" to systematically maintain the PC.

| Stage | Name | Description |
| :--- | :--- | :--- |
| **0** | **Prep** | • Creates System Restore Point (via `Checkpoint-Computer`)<br>• checks S.M.A.R.T. drive health.<br>• Verifies VSS service health. |
| **1** | **TempClean** | • Cleans Temp files (`%TEMP%`, `C:\Windows\Temp`)<br>• Clears Event Logs.<br>• Runs Advanced Disk Cleanup (`cleanmgr /sagerun:1337`). |
| **2** | **Debloat** | • **Safe & Smart**: Removes Metro/UWP bloatware using an **AllowList** strategy.<br>• Keeps critical apps (Calculator, Store, Xbox) intact while nuking everything else. |
| **3** | **Disinfect** | • Orchestrates **Windows Defender**.<br>• Updates Signatures.<br>• Runs Full Scan.<br>• (Optional) Triggers Offline Boot Scan. |
| **4** | **Repair** | • **Self-Healing Loop**: Runs `sfc /scannow`. If corruption is found, runs `dism /restorehealth`, then verifies with `sfc` again.<br>• Checks for Windows Updates via COM. |
| **5** | **Optimize** | • Runs media-aware optimization via `Optimize-Volume`.<br>• Trims SSDs.<br>• Defragments HDDs. |

---

## 🎮 Command Line Arguments

Tron is designed to be fully automated (`-NonInteractive`), but you can customize it:

| Info | Flag | Description |
| :--- | :--- | :--- |
| **Safety** | `-DryRun` | Simulates the run without making ANY changes. **Highly Recommended** for first runs. |
| **Automation** | `-NonInteractive` | Bypasses all prompts (automating admin checks). |
| **Power** | `-AutoReboot` | Automatically reboots the machine if required after completion. |

**Example:**
```powershell
# Run silently and reboot when done
.\tron.exe -NonInteractive -AutoReboot
```

---

## 🛠️ Building from Source

Tron v2.0 uses a **Modular Monolith** build system. The source code lives in `tronsrc/`.

### Prerequisites
*   Windows 10/11
*   PowerShell 5.1

### Build Instructions
To compile the source modules into the final `tron.ps1` and `tron.exe`:

```powershell
cd tronsrc/build
powershell -ExecutionPolicy Bypass -File .\build.ps1
```

**Output:**
*   `tron.ps1` (Single-file script)
*   `tron.exe` (Native wrapper)

---

## 📄 Configuration

Tron uses JSON configuration files located in `tronsrc/config` (which are embedded into the build).

*   **`settings.json`**: Global runtime settings (Log paths, timeouts).
*   **`allowlists.json`**: The list of "Protected" UWP apps for the Debloat stage. Add apps here to prevent them from being removed.

---

## ⚖️ License

MIT License. See [LICENSE](LICENSE) for details.

*Tron v2.0 - Built with 🧠 by Antigravity*
