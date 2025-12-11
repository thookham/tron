# Tron Quick Start Guide ⚡

Get specific with Tron in 5 minutes or less.

## 1. Download & Extract

1. **Download** the latest release (`.exe` or `.zip`) from the [Releases Page](https://github.com/thookham/tron/releases).
    * **Standard (~4MB)**: Requires internet to download tools.
    * **AIO (~300MB)**: Fully offline capable.
2. **Extract** to a folder on your Desktop (e.g., `Desktop\tron`).
    * *Note: Do not run from a temp folder or inside the zip.*

## 2. Run Tron

1. **Right-click** `tron.bat` and select **Run as Administrator**.
2. **Type** `I AGREE` (all caps) when prompted to accept the warnings.
3. **Wait**. The process takes **3-10 hours** depending on your system.

## 3. Post-Run

* **Reboot** your computer.
* Check `C:\logs\tron\tron.log` if you need details.

---

## Common Flags

Run from Command Prompt (Admin) for automation:

```batch
:: Fully automatic: Accept EULA, Auto-Reboot when done
tron.bat -a -r

:: Skip massive tasks: No Bloatware Removal, No Defrag
tron.bat -sb -sd

:: Dry run (Test mode, no changes)
tron.bat -d
```

## Safety Notes

* **Backups**: Tron creates a Restore Point and Backup Registry, but you should **backup your data** externally first.
* **Interruption**: Press `Ctrl+C` to pause/cancel safely.
