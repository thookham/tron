| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v1.2 (2014-07-07)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv1.2).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv1.2




######################
# v1.2 // 2014-07-07 #
######################
tron.bat                           v1.2
 + stage_5_optimize:  Add detection of SSD drives. If drive is detected, post-run defrag is skipped. Thanks u/you_drown_now for help with this function.
 * stage_3_de-bloat:  Improve logic, logging, and robustness for WMIC removal section
 * tron.bat:          Improve overall logging, appearance and commenting. Add clarification screens for various Safe Mode states
 / Intro screen:      Adjust runtime estimates based on user feedback
 / tron.bat:          Disable post-run auto-reboot by default. Change "REBOOT_DELAY" variable if you wish to auto-reboot
 - tron.bat:          Remove section asking user if we want to do a post-run defrag (replaced by auto-detect)
 - stage_1_tempclean: Remove TempFileCleanup job (CCleaner and BleachBit cover this requirement)
 - stage_4_patch:     Remove /r switch on wuauclt command

STAGE 0: Prep
 . Rkill                           v2.6.7

STAGE 1: Tempclean
 - TempFileCleanup                 REMOVED
 . CCleaner                        v4.15.4725
 * BleachBit                       v1.2

STAGE 2: Disinfect
 . Malwarebytes Anti-malware       v2.0.2.1012
 . Sophos Virus Removal Tool       v2.5 (2014-07-06)
 . Vipre Rescue Scanner            v7.0.7.8

STAGE 3: De-bloat target keywords (%% = any number of characters wildcard)
These are specified in: \resources\stage_3_de-bloat\programs_to_target.txt
 . Acer%%
 + Adobe Shockwave%%
 + Advanced%%FX Engine
 + Akamai%%
 + Amazon Browser%%
 . Bing%%
 + Bonjour%%
 + Catalina Savings%%
 . Cyberlink%%
 + Dell Getting Started Guide%%
 + Dell Video%%
 . eBay%%
 . eMachines%%
 . Free Download Manager%%
 + HP Deskjet%%Help
 . Launch Manager%%
 + Lenovo%%
 + Live! Cam Avatar%%
 + Move Media%%
 + My HP%%
 + PowerDVD%%
 + RenWeb%%
 + Roxio%%
 + Sonic CinePlayer%%
 + %%Toolbar%%
 + UserGuide%%
 + Yahoo! Browser%%

STAGE 4: Patch
 . 7-Zip                           v9.20
 . Adobe Flash Player              v14.0.0.125
 . Adobe Reader                    v11.0.07
 . Java Runtime Environment        8u5
 . Notepad++                       v6.6.4
 . Windows updates                 <pulled down live>

STAGE 5: Optimize
 + smartctl                        v6.2 2013-07-26 r3841
 * Defraggler                      v2.18.945

STAGE 6: Manual tools
 . ADSSpy                          v1.11.0.0
 + AdwCleaner                      v3.2.1.4
 . autoruns                        v11.70
 * ComboFix                        v14.7.3.1
 . gmer                            v2.1.19357
 . HiJackThis                      v2.0.4
 . Panda Cloud Security Scanner  updated 2014-07-03
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
