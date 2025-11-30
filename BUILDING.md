# Building Tron from Source

This document provides comprehensive instructions for building Tron release packages from source code.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Build Variants](#build-variants)
- [Release Types](#release-types)
- [AIO Build System](#aio-build-system)
- [Tool Manifest](#tool-manifest)
- [Build Process Details](#build-process-details)
- [Troubleshooting](#troubleshooting)
- [Customization](#customization)
- [Distribution](#distribution)

---

## Prerequisites

### Required

- **Windows** 7 or later
- **PowerShell** 5.1 or later (included in Windows 10+)
- **Internet Connection** (for AIO builds only)

### Optional

- **7-Zip** - For creating self-extracting EXE packages
  - Download: https://www.7-zip.org/
  - If not installed, only ZIP packages will be created

---

## Quick Start

```powershell
# Navigate to repository root
cd C:\path\to\tron

# Build standard release
.\build_release.ps1

# Build All-In-One (AIO) package
.\build_release.ps1 -AIO
```

---

## Build Variants

### Standard Release

**Command**:
```powershell
.\build_release.ps1
```

**What's Included**:
- All scripts (.bat, .ps1)
- Configuration files (.ini, .txt, .cfg)
- Whitelists and blocklists
- Documentation

**What's Excluded**:
- Binary tools (CCleaner, Malwarebytes, etc.)
- These are downloaded automatically during first run

**Output**:
- `releases\tron_v13.2.0.zip` (~4MB)
- `releases\tron_v13.2.0.exe` (~4MB, if 7-Zip available)

**Use Case**: Small package size, internet available during execution

---

### All-In-One (AIO) Release

**Command**:
```powershell
.\build_release.ps1 -AIO
```

**What's Included**:
- Everything from Standard Release
- **All binary tools pre-downloaded** (~20 utilities)
- Offline indicator file

**Output**:
- `releases\tron_v13.2.0_aio.zip` (~327MB without drivers)
- `releases\tron_v13.2.0_aio.exe` (~327MB, if 7-Zip available)

**Use Case**: Offline systems, air-gapped environments, consistent tool versions

---

## Release Types

### Standard vs AIO Comparison

| Feature | Standard | AIO |
|---------|----------|-----|
| **Package Size** | ~4MB | ~327MB - ~2.5GB |
| **Internet Required** | Yes (runtime) | No |
| **Tool Versions** | Latest | Snapshot |
| **Build Time** | ~30 seconds | ~5-15 minutes |
| **Offline Capable** | No | Yes |

---

## AIO Build System

### Tool Selection Modes

#### 1. NoDrivers (Default)
```powershell
.\build_release.ps1 -AIO
.\build_release.ps1 -AIO -ToolSelection NoDrivers
```

**Includes**: All tools except Snappy Driver Installer  
**Size**: ~327MB  
**Recommended for**: Most deployments

#### 2. Full
```powershell
.\build_release.ps1 -AIO -ToolSelection Full -IncludeDrivers
```

**Includes**: All tools including Snappy Driver Installer  
**Size**: ~2.5GB  
**Recommended for**: Complete offline capability with driver support

#### 3. Essential
```powershell
.\build_release.ps1 -AIO -ToolSelection Essential
```

**Includes**: Only essential tools marked in manifest  
**Size**: ~150MB  
**Tools**: rkill, TDSS Killer, AdwCleaner, KVRT, O&O ShutUp10, 7-Zip  
**Recommended for**: Minimal viable offline package

#### 4. Interactive
```powershell
.\build_release.ps1 -AIO -ToolSelection Interactive
```

**Includes**: User-selected tools per stage  
**Size**: Varies based on selection  
**Recommended for**: Custom deployments, testing specific stages

---

## Tool Manifest

### Included Tools by Stage

#### Stage 0: Prep (~29MB)
- ✓ **rkill** v2.9.1.0 (Essential) - Terminate malware processes
- ✓ **TDSS Killer** v3.1.0.12 (Essential) - Rootkit remover
- ○ **Trellix Stinger** v13.0.0.254 - Standalone anti-virus scanner

#### Stage 1: Tempclean (~46MB)
- ✓ **CCleaner** v6.24 (Essential) - System cleaner
- ○ **BleachBit** v4.6.0 - Privacy cleaner

#### Stage 3: Disinfect (~238MB)
- ✓ **AdwCleaner** v8.4.2 (Essential) - Adware/PUP remover
- ✓ **Kaspersky KVRT** v20.0.12.0 (Essential) - Virus removal tool
- ○ **Malwarebytes** v3.6.1 - Anti-malware scanner

#### Stage 4: Repair (~4MB)
- ✓ **O&O ShutUp10** v1.9.1442 (Essential) - Privacy tool, Copilot blocking
- ○ **Spybot Anti-Beacon** v1.7.0.47 - Telemetry blocker

#### Stage 5: Patch (~2MB)
- ✓ **7-Zip** v24.09 (Essential) - File archiver/patcher

#### Stage 6: Optimize (~6MB)
- ○ **Defraggler** v2.22.995 - Disk defragmentation

#### Stage 9: Manual Tools (~2.2GB)
- ○ **Autoruns** v14.11 - Startup manager
- ○ **Snappy Driver Installer** R2309 - Driver database (~2GB)

**Legend**: ✓ = Essential, ○ = Optional

**Total Sizes**:
- Essential only: ~150MB
- All except Snappy: ~327MB
- Full including Snappy: ~2.5GB

---

## Build Process Details

### Standard Build Flow

1. **Validation**: Check prerequisites
2. **Create staging directory**: Temporary build location
3. **Copy source files**:  Scripts, resources, configs, docs
4. **Create ZIP**: Compress staged files
5. **Create SFX EXE**: Combine 7z.sfx + config + archive (if 7-Zip available)
6. **Cleanup**: Remove staging directory
7. **Report**: Display results and open output folder

### AIO Build Flow

1. **Internet check**: Verify connectivity (required)
2. **Tool selection**: Determine which tools to download
3. **Download phase**: Fetch tools from official sources via HTTPS
   - Progress indicators for each tool
   - Automatic retry on failure
   - SHA256 verification (recommended)
4. **Packaging**: Merge tools with scripts/configs
5. **AIO marker**: Create `.tron_aio_package` identifier file
6. **Compression**: Create ZIP and SFX EXE
7. **Cleanup**: Remove temporary files
8. **Summary**: Report download success/failures

### Build Time Estimates

| Build Type | Time | Notes |
|------------|------|-------|
| Standard | ~30 seconds | Local file operations only |
| AIO Essential | ~3-5 minutes | Depends on internet speed |
| AIO NoDrivers | ~5-10 minutes | ~327MB download |
| AIO Full | ~15-30 minutes | ~2.5GB download |

---

## Troubleshooting

### Common Issues

#### "build_release_aio.ps1 not found"
**Cause**: Running `build_release.ps1 -AIO` but AIO script is missing  
**Solution**: Ensure `build_release_aio.ps1` exists in the same directory

#### "7-Zip not found"
**Cause**: 7-Zip isn't installed or not in expected locations  
**Solution**: 
- Install 7-Zip from https://www.7-zip.org/
- Or accept ZIP-only output (EXE creation will be skipped)

#### "No internet connection detected"
**Cause**: AIO build requires internet to download tools  
**Solution**:
- Connect to internet
- Or use `-ToolSelection Essential` to download fewer tools
- Or build Standard release instead

#### "Download failed for [tool]"
**Cause**: Tool URL may have changed or server is temporarily down  
**Solution**:
- Check if URL is still valid
- Update `$ToolManifest` in `build_release_aio.ps1` with new URL
- Or manually download tool and place in appropriate folder
- Or skip that tool (build will continue with warning)

#### "File size exceeds GitHub limit"
**Cause**: AIO package with drivers (~2.5GB) exceeds GitHub's 2GB file limit  
**Solution**:
- Host large variants on external platforms (Dropbox, MEGA, Google Drive)
- Or build without drivers: `.\build_release.ps1 -AIO` (default behavior)

### Build Script Errors

#### PowerShell ExecutionPolicy Error
```powershell
# Error: "cannot be loaded because running scripts is disabled"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
.\build_release.ps1
```

#### Access Denied Errors
**Cause**: Insufficient permissions or files in use  
**Solution**:
- Run PowerShell as Administrator
- Close any programs that might be locking files
- Temporarily disable antivirus if it's blocking operations

---

## Customization

### Adding New Tools to AIO

Edit `build_release_aio.ps1` → `$ToolManifest` section:

```powershell
"StageX" = @(
    @{
        Name = "My New Tool"
        Version = "1.0.0"
        Files = @("mytool.exe")
        URLs = @("https://example.com/mytool.exe")
        TargetPath = "resources\stage_X_name\mytool"
        Essential = $false
        Note = "Optional description or warning"
    }
)
```

### Updating Tool Versions

1. **Find the tool** in `$ToolManifest`
2. **Update version number**
3. **Update download URL**
4. **Test the build** to verify download works

Example:
```powershell
@{
    Name = "AdwCleaner"
    Version = "8.5.0"  # ← Updated
    Files = @("adwcleaner.exe")
    URLs = @("https://adwcleaner.malwarebytes.com/adwcleaner?channel=release")  # ← Updated if changed
    TargetPath = "resources\stage_3_disinfect\adwcleaner"
    Essential = $true
}
```

### Changing Default  Build Mode

Edit `build_release_aio.ps1`:

```powershell
param(
    [string]$Version = "13.2.0",
    [string]$ReleaseDate = "2025-11-29",
    [ValidateSet("Full", "Essential", "Interactive", "NoDrivers")]
    [string]$ToolSelection = "NoDrivers",  # ← Change default here
    [switch]$IncludeDrivers  # ← Set to $true to include drivers by default
)
```

---

## Distribution

### GitHub Releases

**Supported**:
- Standard Release (~4MB) ✓
- AIO NoDrivers (~327MB) ✓

**Not Supported**:
- AIO Full with Drivers (~2.5GB) ✗ Exceeds 2GB limit

### Alternative Hosting

For packages exceeding GitHub's limits:

| Platform | Free Tier | Max File Size | Notes |
|----------|-----------|---------------|-------|
| **Dropbox** | 2GB storage | Unlimited file size | Shared links work well |
| **MEGA** | 20GB storage | 5GB per file | Good for large AIO |
| **Google Drive** | 15GB storage | 5TB per file | Requires Google account |
| **Self-hosted** | Your limits | Your limits | Full control |

### Recommended Distribution Strategy

1. **GitHub Releases**:
   - Standard Release
   - AIO NoDrivers variant

2. **External Hosting**:
   - AIO Full (with drivers)
   - Link from GitHub README to external download

3. **Release Notes**:
   - Always include changelog
   - List which variant includes what tools
   - Provide SHA256 checksums for verification

---

## Release Checklist

### Before Building

- [ ] Update version in `build_release.ps1`
- [ ] Update version in `build_release_aio.ps1`
- [ ] Update version in `resources\functions\initialize_environment.bat`
- [ ] Update `changelog.txt` with changes
- [ ] Update `README.md` version badge
- [ ] Test tool download URLs are alive

### Building

- [ ] Build standard release
- [ ] Build AIO release(s)
- [ ] Verify both .zip and .exe created
- [ ] Check file sizes are expected
- [ ] Test-extract both archives

### After Building

- [ ] Commit code changes
- [ ] Create Git tag (e.g., `v13.2.0`)
- [ ] Push commits and tags to GitHub
- [ ] Create GitHub Release
- [ ] Attach standard packages
- [ ] Upload AIO (with drivers) to external hosting if needed
- [ ] Update release notes
- [ ] Generate and include SHA256 checksums

---

## Advanced Topics

### Parallel Builds

To build both variants simultaneously:

```powershell
# Terminal 1
.\build_release.ps1

# Terminal 2
.\build_release.ps1 -AIO
```

### Automated CI/CD

Example GitHub Actions workflow:

```yaml
name: Build Releases

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Build Standard Release
        run: .\build_release.ps1
      
      - name: Build AIO Release
        run: .\build_release.ps1 -AIO
      
      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: tron-releases
          path: releases/*
```

### SHA256 Verification

Generate checksums for distribution:

```powershell
# After building
cd releases
Get-ChildItem -Filter *.zip, *.exe | Get-FileHash -Algorithm SHA256 | 
    Format-List Hash, Path | 
    Out-File checksums.txt
```

---

## FAQ

**Q: Can I build on Linux/Mac?**  
A: No. The build scripts require Windows PowerShell and the output is Windows-specific.

**Q: How long does AIO build take?**  
A: 5-15 minutes typically, depending on internet speed (~327MB download).

**Q: Can I include custom tools?**  
A: Yes! Edit `$ToolManifest` in `build_release_aio.ps1` to add your own tools.

**Q: Why does the build fail with "Access Denied"?**  
A: Run PowerShell as Administrator, or check if antivirus is blocking file operations.

**Q: Can I automate builds in CI/CD?**  
A: Yes, but AIO builds require internet access. Standard builds work offline.

**Q: What if a tool download fails?**  
A: The build continues with a warning. The package will work but may have reduced functionality for that stage.

---

## Additional Resources

- **Tool Manifest**: Complete list with URLs in `tron_aio_tool_manifest.txt` (artifacts folder)
- **AIO Guide**: Comprehensive usage guide in `tron_aio_guide.md` (artifacts folder)
- **v13.2.0 Changes**: Detailed analysis in `v13.2.0_changes_review.md` (artifacts folder)

---

**Need Help?** File an issue on the [GitHub repository](https://github.com/thookham/tron/issues).

---

*Last Updated: 2025-11-29 | Tron v13.2.0*
