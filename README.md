| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | v1.3 (2014-07-10)                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (ocatus.gate@gmail) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# ðŸ›ï¸ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (vv1.3).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# ðŸ“‹ CHANGELOG FOR vv1.3




######################
# v1.3 // 2014-07-10 #
######################
tron.bat                           v1.3
 + tron.bat:      Add additional checks for SSD drives on /dev/sdb and /dev/sdc
 * stage_4_patch: Update links for Adobe Flash and Notepad++ to reflect new versions

STAGE 0: Prep
 . Rkill                           v2.6.7.0

STAGE 1: Tempclean
 . CCleaner                        v4.15.4725
 - BleachBit                       v1.2

STAGE 2: Disinfect
 . Malwarebytes Anti-malware       v2.0.2.1012
 . Sophos Virus Removal Tool       v2.5 2014-07-10
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
 . Adobe Flash Player              v14.0.0.145
 . Adobe Reader                    v11.0.07
 . Java Runtime Environment        8u5
 . Notepad++                       v6.6.7
 . Windows updates                 <pulled down live>

STAGE 5: Optimize
 + smartctl                        v6.2 2013-07-26 r3841
 * Defraggler                      v2.18.945

STAGE 6: Manual tools
 . ADSSpy                          v1.11.0.0
 + AdwCleaner                      v3.2.1.4
 + aswMBR                          v1.0.1.2041
 * autoruns                        v12.0
 . ComboFix                        v14.7.3.1
 . gmer                            v2.1.19357
 - HiJackThis                      REMOVED, functionality replaced by autoruns.exe
 - Panda Cloud Security Scanner    REMOVED
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
