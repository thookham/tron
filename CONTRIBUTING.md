# Contributing to Tron v2.0

Thank you for your interest in improving Tron! v2.0 represents a major shift to a **Native-First PowerShell Architecture**.

## 🏗️ Repository Structure

Unlike the legacy version, Tron v2.0 is **compiled**. You do not edit `tron.ps1` directly.

```text
/
├── tron.exe            # (Artifact) Final Executable
├── tron.ps1            # (Artifact) Final Script
├── tron.bat            # Legacy Fallback Launcher
└── tronsrc/            # <--- SOURCE CODE LIVES HERE
    ├── build/
    │   └── build.ps1   # The Build System
    ├── config/
    │   ├── settings.json
    │   └── allowlists.json
    └── src/
        ├── core/       # Logging, Elevation, Main Controller
        ├── stages/     # Individual Stage Logic (0-5)
        └── utils/      # Helper functions
```

## 👩‍💻 How to Make Changes

1.  **Edit Source**: Navigate to `tronsrc/src/` and modify the relevant module (e.g., `stages/02_debloat.ps1`).
2.  **Build**: Run the build script to generate the new artifacts.
    ```powershell
    powershell -File tronsrc/build/build.ps1
    ```
3.  **Test**: Run the generated `tron.ps1` or `tron.exe` (use `-DryRun` for safety).

## 🧩 Adding a New Stage

1.  Create a new file in `tronsrc/src/stages/`, e.g., `06_custom.ps1`.
2.  Define a function named `Invoke-Stage06_Custom`.
3.  The build system (`build.ps1`) automatically discovers files in `stages/` and merges them.
4.  The Main Controller (`src/core/main.ps1`) automatically discovers functions matching `Invoke-Stage*` and executes them in alphabetical order.

## 📏 Code Style
*   **PowerShell 5.1 Compatible**: Avoid PowerShell 7-only features to ensure maximum compatibility.
*   **Native-First**: Do not add external binaries unless absolutely necessary. Use .NET, WMI, or CIM.
*   **Glass Box**: Code must be readable and transparent.

## 🧪 Testing
Always run with `-DryRun` first to verify logging and logic flow without modifying the system.
