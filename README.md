| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v1.1 (2014-07-06)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv1.1).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv1.1




######################
# v1.1 // 2014-07-06 #
######################
tron.bat                           v1.1
 * tron.bat:          Comment, log and syntax cleanup
 + tron.bat:          Add section to ask if we want to do a post-run defrag, and skip the defrag if the user says no
 * tron.bat:          Remove hard requirement to run in safe mode and add code to detect various Safe Mode states
 * stage_3_de-bloat:  Convert section to read from a text list located in resource\stage_3_de-bloat\programs_to_target.txt
 + stage_3_de-bloat:  Add additional programs to find and remove
 + stage_3_de-bloat:  Add line to remove Adobe Shockwave (not in wide use anymore)
 - stage_4_patch:     Remove installation of Adobe Shockwave

STAGE 0: Prep
 . Rkill                           v2.6.7

STAGE 1: Tempclean
 . TempFileCleanup                 v3.1
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
 - Adobe Shockwave                 v12.1.2.152 -- REMOVED
 . Java Runtime Environment        8u5
 . Notepad++                       v6.6.4
 . Windows updates                 <pulled down live>

STAGE 5: Optimize
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
