| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v10.2.0 (2017-07-04)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv10.2.0).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv10.2.0




#########################
# v10.2.0 // 2017-07-04 # // Happy Birthday America! God bless the USA.
#########################

 * PROJECT-WIDE: -udl switch (upload debug logs) now emails a screenshot of the system desktop to vocatus since this is often more useful
  in determining the state of the system
 ! BE AWARE THE DESKTOP SCREENSHOT CAN CONTAIN PERSONAL INFORMATION, ONLY USE THE -UDL SWITCH IF YOU'RE OK WITH THIS!
   Again, I don't care what people have on their system, but if there are sensitive document names etc on the desktop, be aware
   there's the possibility I might see them (filenames only, not contents)

 * tron.bat                        v1.0.3

functions
 * initialize_environment.bat      v10.1.1
 . prerun_checks_and_tasks.bat     v1.0.0
 . tron_settings.bat               v1.0.0

Stage 0: Prep
 * stage_0_prep.bat                v1.1.8
 . check_update.bat                v1.0.7
 . check_update_debloat_lists.bat  v1.1.0
 . rkill                           v2.8.4.0
 . ProcessKiller                   v2.0.0-TRON
 . TDSS Killer                     v3.1.0.12
 * McAfee Stinger                  v12.1.0.2421
 . erunt                           v1.1j
 . caffeine                        v1.6.2.0
 . wget                            v1.19.1
 . nircmdc                         v2.81

Stage 1: Tempclean
 . stage_1_tempclean.bat           v1.1.9
 * CCleaner                        v5.31.6105
 . BleachBit                       v1.12
 . finddupe.exe                    v1.23
 . TempFileCleanup                 v1.1.4-TRON
 . USB Device Cleanup              v1.2.0

Stage 2: De-bloat
 * stage_2_de-bloat.bat            v1.3.1
 . programs_to_target_by_GUID.txt
 . toolbars_BHOs_to_target_by_GUID.txt
 . programs_to_target_by_name.txt
 * metro_3rd_party_modern_apps_to_target_by_name.ps1
 . metro_Microsoft_modern_apps_to_target_by_name.ps1

Stage 3: Disinfect
 . stage_3_disinfect.bat           v1.1.8
 . Sophos Virus Removal Tool       v2.5.6
 . Kaspersky Virus Removal Tool    v15.0.19.0
 . Malwarebytes Anti-Malware       v2.2.1.1043
 * Malwarebytes included defs:     2017-06-29

Stage 4: Repair
 . stage_4_repair.bat              v1.2.3
 * purge_windows_7-8-81_telemetry.bat
    + Add additional scheduled tasks to remove. Thanks to u/MirageESO

 . purge_windows_10_telemetry.bat
 . Spybot Anti-Beacon              v1.5.0.35
 . O&O ShutUp10                    v1.4.1387
 . Repair file extensions          v1.0.0

Stage 5: Patch
 . stage_5_patch.bat               v1.2.0
 . 7-Zip                           v16.04        (multi-language)
 * Adobe Flash Player              v26.0.0.131   (language ignored)
 . Adobe Acrobat Reader DC         v15.023.20053 (English-only; replace with your language version if necessary)
 . Java Runtime Environment        8u131         (language ignored)
 . Windows updates                 Pulled down live using: 'wuauclt /detectnow /updatenow'

Stage 6: Optimize
 . stage_6_optimize.bat            v1.0.6
 . smartctl                        v6.5.0.4318 2016-05-07 r4318
 . Defraggler                      v2.21.0.993

Stage 7: Wrap-up
 . SwithMail.exe                   v2.1.8.0

Stage 8: Custom Scripts
 . Tron will execute any .bat file placed in this directory prior to script completion

Stage 9: Manual tools
 . .NET Repair Tool                v4.5.52207.36207
 . ADSSpy                          v1.11.0.0
 . AdwCleaner                      v6.0.4.7
 . Autoruns                        v13.71
 . BlueScreenView                  v1.55
 * ComboFix                        v17.5.24.14
 . Junkware Removal Tool           v8.1.3.0
 . Net Adapter Repair              v1.2
 . PC Hunter                       v1.51 x64
 . PC Hunter                       v1.51 x86
 . Remote Support Reboot Config    v1.0.0
 . Safe Mode Boot Selector.bat     v1.0.0
 . ServicesRepair                  v1.0.0.3
 . Tron Reset Tool                 v1.0.0


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
