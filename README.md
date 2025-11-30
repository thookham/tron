# Tron 🛡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v13.2.0-blue.svg)](https://github.com/thookham/tron/releases)
[![GitHub stars](https://img.shields.io/github/stars/thookham/tron.svg)](https://github.com/thookham/tron/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/thookham/tron.svg)](https://github.com/thookham/tron/network)

**"Tron Fights for the User"**

An automated Windows cleanup, disinfection, and maintenance script that runs a comprehensive series of tools to clean, repair, and optimize Windows systems.

> [!NOTE]
> **Modernized Fork with Working Releases**
> This is a modernized fork of the original Tron project, synced with upstream `bmrf/tron` v12.0.8+ with modern Windows 10/11 support. Unlike the upstream repository, **this fork provides working pre-packaged releases** ready to use!
> 
> **Powered by Google Gemini Antigravity** 🚀

> [!IMPORTANT]
> **📥 DOWNLOAD WORKING RELEASES HERE!**  
> This fork provides **fully functional packaged releases** (both ZIP and EXE formats).
> 
> **Standard Release** (~4MB) - Tools downloaded on first run  
> **AIO Release** (~327MB) - All tools pre-bundled, fully offline-capable
> 
> 👉 **[Get the latest release here](https://github.com/thookham/tron/releases)**

---

## 📑 Table of Contents

- [Overview](#overview)
- [Download Options](#download-options)
- [Key Features](#key-features)
- [System Requirements](#system-requirements)
- [Installation \& Usage](#installation--usage)
- [Building from Source](#building-from-source)
- [Command-Line Options](#command-line-options)
- [Tron Stages](#tron-stages)
  - [Stage 0: Prep](#stage-0-prep)
  - [Stage 1: Tempclean](#stage-1-tempclean)
  - [Stage 2: De-bloat](#stage-2-de-bloat)
  - [Stage 3: Disinfect](#stage-3-disinfect)
  - [Stage 4: Repair](#stage-4-repair)
  - [Stage 5: Patch](#stage-5-patch)
  - [Stage 6: Optimize](#stage-6-optimize)
  - [Stage 7: Wrap-up](#stage-7-wrap-up)
  - [Stage 8: Custom Scripts](#stage-8-custom-scripts)
  - [Stage 9: Manual Tools](#stage-9-manual-tools)
- [Advanced Configuration](#advanced-configuration)
- [Email Reports](#email-reports)
- [Safe Mode](#safe-mode)
- [Changelog](#changelog)
- [Support](#support)
- [Related Projects](#related-projects)
- [License](#license)

---

## Overview

Tron is a glorified collection of batch scripts that automate the tedious process of cleaning up and disinfecting Windows machines. Built with heavy reliance on community input and battle-tested in real-world IT environments, Tron systematically runs through multiple stages of cleanup, disinfection, repair, patching, and optimization.

### What Tron Does

- **Cleans** temporary files, caches, and junk
- **Removes** bloatware, toolbars, and unwanted software
- **Disinfects** with multiple anti-virus and anti-malware scanners
- **Repairs** system files and Windows components
- **Patches** Windows and common software (7-Zip, Adobe products, Java)
- **Optimizes** disk defragmentation and system settings
- **Purges** Windows telemetry and tracking (7/8/8.1/10/11)
- **Generates detailed logs** of all actions taken

## Download Options

This fork provides two release variants to suit different deployment scenarios:

### 🔹 Standard Release (~4MB)

- **What's included**: All scripts, configurations, and logic
- **Tools**: Downloaded automatically on first run
- **Best for**: Systems with reliable internet connection
- **Pros**: Small download, always uses latest tool versions
- **Cons**: Requires internet connection during execution

### 🔸 All-In-One (AIO) Release (~327MB)

- **What's included**: Everything + all binary tools pre-bundled
- **Tools**: Pre-downloaded (~20 utilities)
- **Best for**: Offline systems, air-gapped environments, consistent deployments
- **Pros**: Fully offline-capable, consistent tool versions, faster execution
- **Cons**: Larger download size

> [!TIP]
> **First time using Tron?** Start with the **Standard Release**.  
> **Need offline capability?** Use the **AIO Release**.

📥 **[Download from Releases Page](https://github.com/thookham/tron/releases)**

---

## Key Features

✅ **Completely Automated** - Set it and forget it  
✅ **Comprehensive** - 9 stages covering all aspects of system maintenance  
✅ **Battle-Tested Tools** - Uses industry-standard utilities (Malwarebytes, Kaspersky, etc.)  
✅ **Modern Windows Support** - Windows 7/8/8.1/10/11 and Server 2003-2022  
✅ **Massive Bloatware Database** - 16,000+ entries targeting OEM bloat and toolbars  
✅ **Telemetry Removal** - Comprehensive Windows 7/8/8.1/10/11 tracking removal  
✅ **Copilot Recall Blocking** - Disables Windows 11 screenshot/keyboard recording  
✅ **Detailed Logging** - Complete logs of all actions and results  
✅ **Safe Mode Support** - Can run in Safe Mode for stubborn infections  
✅ **Email Reports** - Optionally email results when complete  
✅ **Custom Scripts** - Execute your own scripts at completion  
✅ **Resume Support** - Can resume if interrupted  
✅ **AIO Packages** - Offline-capable releases with all tools pre-bundled  

## System Requirements

- **OS**: Windows XP, Vista, 7, 8, 8.1, 10, 11, Server 2003-2022
- **Disk Space**: ~2 GB free space recommended
- **Time**: 3-10 hours depending on system state
- **Permissions**: Must run as Administrator
- **Network**: Internet connection for updates and definitions

## Installation & Usage

### Basic Usage

1. **Download** the complete Tron pack from the [Releases](https://github.com/thookham/tron/releases) page.
   - Choose **Standard** (~4MB) or **AIO** (~327MB) variant
   - **Do NOT** clone or download source code - use packaged releases

2. **Extract** the entire package to your Desktop or a permanent location

3. **Run as Administrator**:
   - Right-click `tron.bat`
   - Select "Run as Administrator"

4. **Wait** for completion (3-10 hours typical)

5. **Reboot** when prompted

### Quick Start Example

```batch
:: Navigate to Tron directory
cd C:\tron

:: Run Tron with default settings
tron.bat

:: Run with automatic reboot at completion
tron.bat -ar

:: Run in Safe Mode with Network Drivers
tron.bat -sm
```

## Command-Line Options

Tron supports various command-line flags for customization:

| Flag | Description |
|------|-------------|
| `-a` | Accept EULA automatically (no prompts) |
| `-c` | Config dump: Display current settings and exit |
| `-d` | Dry run: Run through script but don't execute jobs |
| `-dev` | Override OS detection (allow running on unsupported OS) |
| `-e` | Email: Send email report upon completion |
| `-er` | Email (error): Send email only on script error |
| `-m` | Preserve default Metro apps (don't remove them) |
| `-np` | Skip patches (Stage 5) |
| `-o` | Power options: Leave power settings at default |
| `-p` | Preserve power settings (don't reset to "High Performance") |
| `-r` | Reboot: Reboot automatically 30 seconds after script completion |
| `-sa` | Skip anti-virus scans (Sophos, Kaspersky, MBAM) |
| `-sb` | Skip de-bloat (OEM bloatware removal) |
| `-sd` | Skip Defrag (Stage 6) |
| `-se` | Skip Event Log clearing |
| `-sm` | Skip Metro (Modern/Universal) app removal |
| `-sp` | Skip patches (Stage 5: patch 7-Zip, Java, Adobe Flash, etc) |
| `-spr` | Skip page file settings reset |
| `-ss` | Skip Sophos anti-virus scan |
| `-str` | Skip Telemetry Removal (don't remove Windows user tracking) |
| `-sw` | Skip Windows Updates (Stage 5) |
| `-v` | Verbose: Show as much output as possible |
| `-x` | Self-destruct: Tron deletes itself after running |

### Usage Examples

```batch
:: Accept EULA, reboot automatically, send email on completion
tron.bat -a -r -e

:: Skip bloatware removal and defrag
tron.bat -sb -sd

:: Verbose mode with automatic reboot
tron.bat -v -r

:: Dry run to see what would happen (no actual changes)
tron.bat -d
```

## Tron Stages

Tron executes in sequential stages. Each stage has a specific purpose and can be skipped via command-line flags if needed.

### Stage 0: Prep

**Purpose**: System preparation and initial malware killing

| Tool | Version | Description |
|------|---------|-------------|
| rkill | v2.9.1.0 | Kills known malware processes |
| ProcessKiller | v2.0.0-TRON | Additional malware process termination |
| TDSS Killer | v3.1.0.12 | Rootkit detection and removal |
| TrelliX Stinger | v13.0.0.254 | Standalone anti-virus scanner |
| ERUNT | v1.1j | Emergency Recovery Utility NT (registry backup) |
| Caffeine | v1.6.2.0 | Prevents system sleep during execution |
| wget | v1.21.4 | Downloads updated definitions |
| nircmdc | v2.87 | Command-line utilities |

**Actions**:
- Create system restore point
- Backup registry
- Kill running malware processes
- Download latest definitions
- Check for script updates

### Stage 1: Tempclean

**Purpose**: Remove temporary files and clear caches

| Tool | Version | Description |
|------|---------|-------------|
| CCleaner | v6.24.11060 | System cleaner |
| BleachBit | v1.12 | Open-source system cleaner |
| finddupe | v1.25 | Duplicate file finder |
| TempFileCleanup | v1.2.2-TRON | Custom temp file cleanup |
| USB Device Cleanup | v1.6.5 | Remove ghost USB devices |

**Cleaned Locations**:
- `%TEMP%` and `C:\Windows\Temp`
- Internet Explorer cache
- Windows update cache
- User profile temp folders
- Recycle bin
- Windows error reports
- And many more...

### Stage 2: De-bloat

**Purpose**: Remove pre-installed bloatware, toolbars, and unwanted software

**Removal Methods**:
- Remove by GUID (global unique identifier)
- Remove by program name
- Remove Metro/Modern/Universal apps (Windows 8/10/11)
- Remove toolbars and browser helper objects (BHOs)

**Target Lists**:
- `programs_to_target_by_GUID.txt` - Programs removed by GUID
- `programs_to_target_by_name.txt` - Programs removed by name
- `toolbars_BHOs_to_target_by_GUID.txt` - Toolbars and addons
- `metro_3rd_party_modern_apps_to_target_by_name.ps1` - 3rd party Windows apps
- `metro_Microsoft_modern_apps_to_target_by_name.ps1` - Microsoft bloat apps

**Registry Tweaks**:
- Disable "How-to Tips" on Windows 8+

### Stage 3: Disinfect

**Purpose**: Scan for and remove viruses, malware, and rootkits

| Tool | Version | Description |
|------|---------|-------------|
| Malwarebytes AdwCleaner | v8.4.2 | Adware removal tool |
| Kaspersky Virus Removal Tool | v20.0.12.0 | Kaspersky's standalone scanner |
| Malwarebytes Anti-Malware | v3.6.1 | Industry-standard anti-malware |

**Process**:
1. Update virus definitions
2. Run full system scans
3. Quarantine/remove detected threats
4. Log all findings

### Stage 4: Repair

**Purpose**: Repair system files and remove Windows telemetry

| Tool | Version | Description |
|------|---------|-------------|
| SFC (System File Checker) | Built-in | Repair corrupted system files |
| DISM | Built-in | Repair Windows image |
| Spybot Anti-Beacon | v1.7.0.47 | Block telemetry/tracking |
| O&O ShutUp10 | v1.9.1442 | Privacy configuration tool |

**Telemetry Removal**:
- `purge_windows_7-8-81_telemetry.bat` - Remove Win 7/8/8.1 tracking
- `purge_windows_10_telemetry.bat` - Remove Win 10/11 tracking and Cortana data collection

**Registry Fixes**:
- Disable AllowCortanaAboveLock
- Disable AllowSearchToUseLocation
- Repair file associations
- DISM health scan and repair

### Stage 5: Patch

**Purpose**: Update Windows and common third-party software

| Software | Version | Notes |
|----------|---------|-------|
| 7-Zip | v24.09 | Multi-language |
| Windows Updates | Live | Via `wuauclt /detectnow /updatenow` |

**Process**:
1. Update Windows Defender definitions
2. Run Windows Update
3. Install/update common software
4. Verify installations

### Stage 6: Optimize

**Purpose**: Optimize disk and check drive health

| Tool | Version | Description |
|------|---------|-------------|
| smartctl | v7.4.1 | S.M.A.R.T. disk analysis |
| drivedb.h | 2025-01-09 | Drive database |
| Defraggler | v2.22.995 | Disk defragmentation |

**Actions**:
- Check S.M.A.R.T. status of all drives
- Log drive health info
- Defragment all drives (HDD only - skips SSDs)
- Optimize drive performance

### Stage 7: Wrap-up

**Purpose**: Collect logs and send reports

| Tool | Version | Description |
|------|---------|-------------|
| SwithMail | v2.2.4.0 | Email report sender |

**Actions**:
- Collect all logs into summary report
- Generate email report (if `-e` flag used)
- Prepare system for reboot
- Display completion message

### Stage 8: Custom Scripts

**Purpose**: Execute user-provided custom scripts

Tron will automatically execute any `.bat` files placed in the `\tron\resources\stage_8_custom_scripts\` directory. This allows you to run custom cleanup, configuration, or deployment scripts as part of the Tron process.

**Usage**:
1. Place your `.bat` scripts in `\resources\stage_8_custom_scripts\`
2. Tron will execute them automatically before completion
3. Scripts run with SYSTEM privileges

### Stage 9: Manual Tools

**Purpose**: Manually available tools for technician use

These tools are included but NOT run automatically. They're available for manual use if needed:

| Tool | Version | Description |
|------|---------|-------------|
| ADSSpy | v1.11.0.0 | Alternate Data Stream scanner |
| Autoruns | v14.11 | Startup program manager |
| BlueScreenView | v1.55 | BSOD crash dump analyzer |
| Net Adapter Repair | v1.2 | Network adapter reset tool |
| Remote Support Reboot Config | v1.0.0 | Configure reboot behavior |
| Safe Mode Boot Selector | v1.0.0 | Easy Safe Mode boot |
| ServicesRepair | v1.0.0.3 | Repair Windows services |
| Snappy Driver Installer | R2309 | Driver installer |
| Tron Reset Tool | v1.0.0 | Reset Tron to run again |

**Location**: `\tron\resources\stage_9_manual_tools\`

## Advanced Configuration

### Changing Defaults

Tron's default settings can be modified by editing environment variables in `tron_settings.bat`:

```batch
:: Example custom settings
set AUTORUN=yes              :: Skip EULA prompt
set PRESERVE_POWER_PLAN=no   :: Reset to High Performance
set SKIP_DEFRAG=no          :: Run defragmentation
set EMAIL_REPORT=yes        :: Send email when done
```

**Location**: `\tron\resources\functions\tron_settings.bat`

### Custom Script Execution

Place `.bat` files in:
```
\tron\resources\stage_8_custom_scripts\
```

Examples:
- Deploy software
- Configure settings
- Join domain
- Install drivers

### WSUS Offline Updates

To bundle WSUS Offline updates with Tron:

1. Download WSUS Offline Update tool
2. Generate update package
3. Place in `\tron\resources\stage_5_patch\wsus_offline\`
4. Tron will detect and install automatically

## Email Reports

### Configuration

Edit `\tron\resources\stage_7_wrap-up\email_settings.bat`:

```batch
set SMTP_SERVER=smtp.gmail.com
set SMTP_PORT=587
set SMTP_USER=your-email@gmail.com
set SMTP_PASS=your-app-password
set EMAIL_TO=recipient@domain.com
```

### Usage

```batch
:: Send email on completion
tron.bat -e

:: Send email only on error
tron.bat -er
```

## Safe Mode

To run Tron in Safe Mode with Networking:

1. **Boot to Safe Mode**:
   - Windows 7: Press F8 during boot
   - Windows 8/10/11: Use shift+restart → Troubleshoot → Advanced
   
2. **Run Tron**:
   ```batch
   tron.bat -sm
   ```

**Note**: Some tools may not work in Safe Mode, but core functionality remains.

## Script Interruption

Tron can be safely interrupted and resumed:

- Press `Ctrl+C` to pause
- Choose to:
  - Continue
  - Skip current stage
  - Quit

On next run, Tron will ask if you want to resume from where it left off.

## Changelog

### v13.2.0 // 2025-11-29

**Major Upstream Sync**:
- Synced with `bmrf/tron` v12.0.8+ (6+ years of updates)
- Added modern Windows 10/11 support
- **16,000+ new bloatware/toolbar entries**
- Copilot Recall blocking (O&O ShutUp10 v1.9.1442)
- Comprehensive telemetry removal (953 lines of code)
- Updated all core scripts and tools

**Build System**:
- New AIO (All-In-One) package builder
- Offline-capable releases with pre-bundled tools
- Interactive and preset build modes
- Maintained working release packaging

See [changelog.txt](changelog.txt) for complete version history.

## Support

- **Issues**: Please file issues in this repository for bugs related to this fork.
- **Upstream**: [bmrf/tron](https://github.com/bmrf/tron)

## Related Projects

Part of the Tron ecosystem:

- **[tron_standalone_scripts](https://github.com/thookham/tron_standalone_scripts)** - Individual Tron utilities
- **[tron_PowerShell](https://github.com/thookham/tron_PowerShell)** - PowerShell-based Tron tools

## License

**MIT License**

Copyright (c) 2014-2025 Vocatus Gate

Tron and any included subscripts and `.reg` files are free to use, redistribute, and modify under the MIT license.

See [LICENSE](LICENSE) for details.

---

**⚠️ Important Reminders**

1. **Always get the FULL PACKAGE** from Releases - GitHub code alone won't work
2. **Backup your data** before running - though Tron creates restore points
3. **Allow 3-10 hours** for completion - don't interrupt unnecessarily
4. **Test in a VM first** if you're unfamiliar with what Tron does

---

*"I fight for the users!" — Tron, 1982*
