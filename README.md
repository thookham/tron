| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v1.9.0 (2014-08-04)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv1.9.0).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv1.9.0




########################
# v1.9.0 // 2014-08-04 #
########################
tron.bat                           v1.9.0
 + tron.bat: Add support for the following optional command-line switches (can be combined):
    -c  Config dump (display current variables)
    -d  Dry run. Run through Tron without executing any jobs (mostly for my testing)
    -s  Skip defrag. Force Tron to skip defrag regardless whether an SSD is detected
    -h  Spit out help on using Tron via command-line
    -r  Reboot (auto-reboot 30 seconds after completion)
 * tron.bat: Improved logic block handling command-line switches; we can now parse switches in any order. Thanks u/Undeadlord for suggestion
 - tron.bat: Removed support for --auto switch (use -a instead)
 ! prep and checks: Fix Admin rights check for Windows 8/8.1 (again); Revert to hard-exit if non-Admin detected

STAGE 0: Prep
 . Rkill                           v2.6.7.0

STAGE 1: Tempclean
 * CCleaner                        v4.16.4763
 . BleachBit                       v1.2

STAGE 2: Disinfect
 * Sophos Virus Removal Tool       v2.5
 * Vipre Rescue Scanner            v7.0.7.8
 * Emsisoft Commandline Scanner    v9.0.0.4183
 . Malwarebytes Anti-Malware       v2.0.2.1012.exe

STAGE 3: De-bloat ( Specified in: \resources\stage_3_de-bloat\programs_to_target.txt )

STAGE 4: Patch
 . 7-Zip                           v9.20
 . Adobe Flash Player              v14.0.0.145
 . Adobe Reader                    v11.0.07
 . Java Runtime Environment        8u11
 * Notepad++                       v6.6.8
 . Windows updates                 <pulled down live>

STAGE 5: Optimize
 . smartctl                        v6.2 2013-07-26 r3841
 . Defraggler                      v2.18.945

STAGE 6: Manual tools
 . ADSSpy                          v1.11.0.0
 * AdwCleaner                      v3.3.0.2
 . aswMBR                          v1.0.1.2041
 . autoruns                        v12.0
 * ComboFix                        v14.8.2.2
 . gmer                            v2.1.19357
 . Junkware Removal Tool           v6.1.4
 . TDSSKiller                      v3.0.0.40
 . TempFileCleaner                 v3.1.9.0
 . VirusTotal uploader tool        v2.2


---

# ðŸ“– DESCRIPTION

Tron is an automated script that runs a series of tools to clean, disinfect, and patch a Windows system.

# ðŸš€ USE

1.  **Download**: Get the release.
2.  **Run**: Right-click 	ron.bat and select "**Run as Administrator**".
3.  **Wait**: The scan can take 3-10 hours.
4.  **Reboot**: Reboot the system when finished.

> [!NOTE]
> This is a legacy version. For the latest features and fixes, please use the latest release.

---

# âš–ï¸ LICENSE

Tron and any included subscripts and .reg files I've written are free to use/redistribute/whatever under the **MIT license**.
