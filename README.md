# Tron 🛡️

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-v10.3.0-blue.svg)]( https://github.com/thookham/tron/releases)
[![Status](https://img.shields.io/badge/status-archived-orange.svg)](https://github.com/bmrf/tron)
[![GitHub stars](https://img.shields.io/github/stars/thookham/tron.svg)](https://github.com/thookham/tron/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/thookham/tron.svg)](https://github.com/thookham/tron/network)

**"Tron Fights for the User"**

An automated Windows cleanup, disinfection, and maintenance script that runs a comprehensive series of tools to clean, repair, and optimize Windows systems.

> [!WARNING]
> **This is an archived version of Tron (v10.3.0 from 2017-11-06).**
> 
> This repository is preserved for historical purposes and reference. For the **latest active development** and current features, please visit:
> - **[bmrf/tron](https://github.com/bmrf/tron)** - Official upstream repository (latest: v13.1.0)
> - **[r/TronScript](https://old.reddit.com/r/TronScript)** - Official subreddit for downloads and support
> 
> **Edits powered by Google Gemini Antigravity**

> [!CAUTION]
> **DO NOT DOWNLOAD TRON FROM GITHUB DIRECTLY!**  
> Downloading source code from GitHub will NOT work. You need the complete packaged release from [r/TronScript](https://old.reddit.com/r/TronScript).

---

## 📑 Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [System Requirements](#system-requirements)
- [Installation \& Usage](#installation--usage)
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
- **Purges** Windows telemetry and tracking (7/8/8.1/10)
- **Generates detailed logs** of all actions taken

## Key Features

✅ **Completely Automated** - Set it and forget it  
✅ **Comprehensive** - 9 stages covering all aspects of system maintenance  
✅ **Battle-Tested Tools** - Uses industry-standard utilities (Malwarebytes, Kaspersky, etc.)  
✅ **Telemetry Removal** - Removes Windows 7/8/8.1/10 tracking and data collection  
✅ **Detailed Logging** - Complete logs of all actions and results  
✅ **Safe Mode Support** - Can run in Safe Mode for stubborn infections  
✅ **Email Reports** - Optionally email results when complete  
✅ **Custom Scripts** - Execute your own scripts at completion  
✅ **Resume Support** - Can resume if interrupted  

## System Requirements

- **OS**: Windows XP, Vista, 7, 8, 8.1, 10, Server 2003-2016
- **Disk Space**: ~1 GB free space recommended
- **Time**: 3-10 hours depending on system state
- **Permissions**: Must run as Administrator
- **Network**: Internet connection for updates and definitions

## Installation & Usage

### Basic Usage

1. **Download** the complete Tron pack from [r/TronScript](https://old.reddit.com/r/TronScript)
   - **Do NOT** clone or download from GitHub - it won't work without all bundled tools

2. **Extract** the entire package to a location (e.g., `C:\tron`)

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
| `- e` | Email: Send email report upon completion |
| `-er` | Email (error): Send email only on script error |
| `-m` | Preserve default Metro apps (don't remove them) |
| `-np` | Skip  patches (Stage 5) |
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
| McAfee Stinger | v12.1.0.2565 | Standalone anti-virus scanner |
| ERUNT | v1.1j | Emergency Recovery Utility NT (registry backup) |
| Caffeine | v1.6.2.0 | Prevents system sleep during execution |
| wget | v1.19.1 | Downloads updated definitions |
| nircmdc | v2.81 | Command-line utilities |

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
| CCleaner | v5.36.6278 | System cleaner |
| BleachBit | v1.12 | Open-source system cleaner |
| finddupe | v1.23 | Duplicate file finder |
| TempFileCleanup | v1.1.4-TRON | Custom temp file cleanup |
| USB Device Cleanup | v1.2.0 | Remove ghost USB devices |

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
- Remove Metro/Modern/Universal apps (Windows 8/10)
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
| Sophos Virus Removal Tool | v2.6.1 | Enterprise-grade virus scanner |
| Kaspersky Virus Removal Tool | v15.0.19.0 | Kaspersky's standalone scanner |
| Malwarebytes Anti-Malware | v2.2.1.1043 | Industry-standard anti-malware |

**Process**:
1. Update virus definitions
2. Run full system scans
3. Quarantine/remove detected threats
4. Log all findings

**MBAM Definitions**: 2017-10-19 (included)

### Stage 4: Repair

**Purpose**: Repair system files and remove Windows telemetry

| Tool | Version | Description |
|------|---------|-------------|
| SFC (System File Checker) | Built-in | Repair corrupted system files |
| DISM | Built-in | Repair Windows image |
| Spybot Anti-Beacon | v1.5.0.35 | Block telemetry/tracking |
| O&O ShutUp10 | v1.6.1393 | Privacy configuration tool |

**Telemetry Removal**:
- `purge_windows_7-8-81_telemetry.bat` - Remove Win 7/8/8.1 tracking
- `purge_windows_10_telemetry.bat` - Remove Win 10 tracking and Cortana data collection

**Registry Fixes**:
- Disable AllowCortanaAboveLock
- Disable AllowSearchToUseLocation
- Repair file associations
- DISM health scan and repair

### Stage 5: Patch

**Purpose**: Update Windows and common third-party software

| Software | Version | Notes |
|----------|---------|-------|
| 7-Zip | v16.04 | Multi-language |
| Adobe Flash Player | v27.0.0.183 | All languages |
| Adobe Acrobat Reader DC | v15.023.20053 | English only* |
| Java Runtime Environment | 8u152 | All languages |
| Windows Updates | Live | Via `wuauclt /detectnow /updatenow` |

\* *Replace with your language version if needed*

**Process**:
1. Update Windows Defender definitions
2. Run Windows Update
3. Install/update common software
4. Verify installations

### Stage 6: Optimize

**Purpose**: Optimize disk and check drive health

| Tool | Version | Description |
|------|---------|-------------|
| smartctl | v6.6.0.4594 | S.M.A.R.T. disk analysis |
| drivedb.h | 2017-11-06 | Drive database |
| Defraggler | v2.21.0.993 | Disk defragmentation |

**Actions**:
- Check S.M.A.R.T. status of all drives
- Log drive health info
- Defragment all drives (HDD only - skips SSDs)
- Optimize drive performance

### Stage 7: Wrap-up

**Purpose**: Collect logs and send reports

| Tool | Version | Description |
|------|---------|-------------|
| SwithMail | v2.1.8.0 | Email report sender |

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
| AdwCleaner | v7.0.4.0 | Adware removal tool |
| Autoruns | v13.80 | Startup program manager |
| BlueScreenView | v1.55 | BSOD crash dump analyzer |
| ComboFix | v17.10.17.1 | Malware removal tool (use with caution!) |
| Junkware Removal Tool | v8.1.4.0 | Junkware cleaner |
| Net Adapter Repair | v1.2 | Network adapter reset tool |
| PC Hunter | v1.51 (x86/x64) | Advanced system information |
| Remote Support Reboot Config | v1.0.0 | Configure reboot behavior |
| Safe Mode Boot Selector | v1.0.0 | Easy Safe Mode boot |
| ServicesRepair | v1.0.0.3 | Repair Windows services |
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
   - Windows 8/10: Use shift+restart → Troubleshoot → Advanced
   
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

### v10.3.0 // 2017-11-06

**Stage 2 Updates**:
- Add reg entry to disable "How-to Tips" on Windows 8+

**Stage 4 Updates**:
- Add disabling of registry keys `AllowCortanaAboveLock` and `AllowSearchToUseLocation`

**Stage 5 Updates**:
- Update Windows Defender prior to Windows Update (fixes update bug)

**Tool Updates**:
- McAfee Stinger: v12.1.0.2565
- CCleaner: v5.36.6278
- Adobe Flash Player: v27.0.0.183
- O&O ShutUp10: v1.6.1393
- AdwCleaner: v7.0.4.0
- smartctl/drivedb: Updated

See [changelog.txt](changelog.txt) for complete version history (14,981 lines, 15 years of development!).

## Support

### For This Archived Version

This is an archived release. For historical reference only.

### For Current Tron

- **Subreddit**: [r/TronScript](https://old.reddit.com/r/TronScript)
- **Official Repo**: [bmrf/tron](https://github.com/bmrf/tron)
- **Issues**: Use the official repo for bug reports
- **Common Questions**: [Tron FAQ](https://www.reddit.com/r/TronScript/wiki/index#wiki_cq_.28common_questions.29)

## Related Projects

Part of the Tron ecosystem:

- **[bmrf/tron](https://github.com/bmrf/tron)** - Official upstream repository (active development)
- **[tron_standalone_scripts](https://github.com/thookham/tron_standalone_scripts)** - Individual Tron utilities
- **[tron_PowerShell](https://github.com/thookham/tron_PowerShell)** - PowerShell-based Tron tools

## License

**MIT License**

Copyright (c) 2014 Vocatus Gate

Tron and any included subscripts and `.reg` files are free to use, redistribute, and modify under the MIT license.

See [LICENSE](LICENSE) for details.

---

## Acknowledgments

- **Vocatus Gate (bmrf)** - Original creator and maintainer
- **r/TronScript Community** - Continuous feedback and contributions
- **Tool Authors** - All the amazing developers who created the bundled utilities
- **Contributors** - 40+ GitHub contributors over the years

---

**⚠️ Important Reminders**

1. **Always get the FULL PACKAGE** from [r/TronScript](https://old.reddit.com/r/TronScript) - GitHub code alone won't work
2. **This is an ARCHIVED version** - Use [bmrf/tron](https://github.com/bmrf/tron) for latest features
3. **Backup your data** before running - though Tron creates restore points
4. **Allow 3-10 hours** for completion - don't interrupt unnecessarily
5. **Test in a VM first** if you're unfamiliar with what Tron does

---

*"I fight for the users!" — Tron, 1982*
