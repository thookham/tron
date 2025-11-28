| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v10.0.0 (2017-02-09)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv10.0.0).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv10.0.0




#########################
# v10.0.0 // 2017-02-09 #  ! Major breaking changes in this release, READ THE NOTES
#########################
Significant changes:
 - Tron now supports using bundled WSUS Offline update packages. Read the instructions file or Github readme for information on how to use WSUS Offline with Tron
 - All Tron configuration options moved out of tron.bat and into: \tron\resources\functions\tron_settings.bat
   Use this to change defaults (or just drop your own custom settings file over top of the default one)
 - Tron project version moved out of tron.bat and into:           \tron\resources\functions\initialize_environment.bat
 - Most Tron prep and checks moved out of tron.bat and into:      \tron\resources\functions\prerun_prep_and_checks.bat

 - All sub-stage scripts now support standalone execution (Tron directory structure and supporting files must still be intact). Use at your own risk
 - New -scs switch and associated SKIP_CUSTOM_SCRIPTS variable. Use this to force Tron to always skip Stage 8 even if custom scripts are present
 - New -swo switch and associated SKIP_WSUS_OFFLINE variable. Use this to force Tron to ignore WSUS Offline update files if they're present
 - Rename -sp switch to -sap
 - Rename -sw switch to -swu


 * tron.bat                        v1.0.0
     * Major breaking changes; VERSION in this script now just refers to tron.bat and NOT the overall Tron project version
       Tron overall project version now resides in \resources\functions\initialize_environment.bat. See that file for more details
     + Add REPO_TRON_VERSION and REPO_TRON_DATE to config dump (-c) output
     + Add switch -scs and associated SKIP_CUSTOM_SCRIPTS variable to allow forcibly skipping Stage 8 (custom scripts). This only has
       effect if .bat files exist in the stage_8_custom_scripts directory. If nothing is there then this option has no effect
     + Add switch -swo and associated SKIP_WSUS_OFFLINE variable to allow forcibly skipping bundled WSUS Offline updates even if they're
       present in stage_5_patch\wsus_offline\client\Update.cmd. Online Windows Updates will still be attempted
     / Change -sp switch and associated SKIP_PATCHES variable to -sap and SKIP_APP_PATCHES to be consistent with other skip switches
     / Change -sw switch (SKIP_WINDOWS_UPDATE) to -swu to be consistent with other skip switches
     - Move task "Enable F8 Key on Bootup" to prerun_checks_and_tasks.bat
     - Move task "Create log directories if they don't exist" to initialize_environment.bat
     * Update welcome screen with note about Stage 8: Custom scripts


functions
 + initialize_environment.bat      v10.0.0  <---  Tron project version number
    . Initializes Tron's runtime environment. It also contains and determines the overall project version and date
      NOTE: Sub-stage scripts rely on this script to function if executed outside of a Tron run (e.g. when run standalone)

 + prerun_checks_and_tasks.bat     v1.0.0
    . Performs many of Tron's prerun checks and tasks (admin rights check, network connection check, etc)

 + tron_settings.bat               v1.0.0
    + Contains Tron's default settings. Edit this file to change those defaults
	  NOTE: Sub-stage scripts rely on this script to function if executed outside of a Tron run (e.g. when run standalone)


Stage 0: Prep
 * stage_0_prep.bat                v1.1.6
     * script: Update script to support standalone execution
     ! erunt:  Don't wait for ERUNT to finish; launch it, wait 15 seconds, then continue. This is to prevent getting stalled on a rare error which causes a popup msg on Win10

 * check_update.bat                v1.0.7
 . check_update_debloat_lists.bat  v1.1.0
 . rkill                           v2.8.4.0
 . ProcessKiller                   v2.0.0-TRON
 . TDSS Killer                     v3.1.0.11
 * McAfee Stinger                  v12.1.0.2259
 . erunt                           v1.1j
 . caffeine                        v1.6.2.0
 . wget                            v1.18
 . nircmdc                         v2.81

Stage 1: Tempclean
 * stage_1_tempclean.bat           v1.1.7
    * Update script to support standalone execution

 . CCleaner                        v5.26.5937
 . BleachBit                       v1.12
 . finddupe.exe                    v1.23
 . TempFileCleanup                 v1.1.4-TRON
 . USB Device Cleanup              v1.2.0

Stage 2: De-bloat
 * stage_2_de-bloat.bat            v1.2.7
    * Update script to support standalone execution
	! Fix for previous fix (shakes head at self), was accidentally disabling sync instead of ENABLING. Thanks to u/Gyllius

 . programs_to_target_by_GUID.txt
 . toolbars_BHOs_to_target_by_GUID.txt
 . programs_to_target_by_name.txt
 . metro_3rd_party_modern_apps_to_target_by_name.ps1
 * metro_Microsoft_modern_apps_to_target_by_name.ps1
    - Remove Calendar and Mail app from active target list. Thanks to u/Reynbou

Stage 3: Disinfect
 * stage_3_disinfect.bat           v1.1.6
    * Update script to support standalone execution

 . Sophos Virus Removal Tool       v2.5.6
 . Kaspersky Virus Removal Tool    v15.0.19.0
 . Malwarebytes Anti-Malware       v2.2.1.1043
 . Malwarebytes included defs:     2017-02-02

Stage 4: Repair
 * stage_4_repair.bat              v1.2.2
    * Update script to support standalone execution

 . purge_windows_7-8-81_telemetry.bat
 . purge_windows_10_telemetry.bat
 . Spybot Anti-Beacon              v1.5.0.35
 . O&O ShutUp10                    v1.4.1386
 . Repair file extensions          v1.0.0

Stage 5: Patch
 * stage_5_patch.bat               v1.1.6
    * Update script to support standalone execution
    + Add support for bundled WSUS Offline updates. Thanks to u/TootZoot for initial template code
    / change :skip_updates and associated GOTO statements to :skip_application_updates
    / change various text and strings referring to SKIP_UPDATES to SKIP_APP_UPDATES

 . 7-Zip                           v16.04        (multi-language)
 * Adobe Flash Player              v24.0.0.194   (language ignored)
    * Flash installation script now supports standalone execution (for example if you just want to update all versions of Flash on the machine)
    * Improve existing Flash installation detection; add granular tests per version. Thanks to u/nubduck
    * Catch additional Flash Updater scheduled task that gets installed

 * Adobe Acrobat Reader DC         v15.023.20053 (English-only; replace with your language version if necessary)
    * Update installation script to block the stupid plugin Adobe loads into Chrome without permission

 . Java Runtime Environment        8u121         (language ignored)
 . Windows updates                 Pulled down live using: 'wuauclt /detectnow /updatenow'

Stage 6: Optimize
 * stage_6_optimize.bat            v1.0.4
    * Update script to support standalone execution

 . smartctl                        v6.5.0.4318 2016-05-07 r4318
 . Defraggler                      v2.21.0.993

Stage 7: Wrap-up
 . SwithMail.exe                   v2.1.8.0

Stage 8: Custom Scripts
 . Tron will execute any .bat file placed in this directory prior to script completion

Stage 9: Manual tools
 . .NET Repair Tool                v4.5.52207.36207
 . ADSSpy                          v1.11.0.0
 * AdwCleaner                      v6.0.4.3
 . Autoruns                        v13.62
 . BlueScreenView                  v1.55
 * ComboFix                        v17.1.29.1
 . Junkware Removal Tool           v8.1.0.0
 . Net Adapter Repair              v1.2
 . PC Hunter                       v1.35 x64
 . PC Hunter                       v1.35 x86
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
