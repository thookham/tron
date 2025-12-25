# Building Tron v2.0

Tron v2.0 uses a custom PowerShell build system to compile its modular source into a single portable entity.

## The Build Artifacts
Running the build produces two files in the project root:
1.  **`tron.ps1`**: A single-file PowerShell script containing all logic, configuration, and stages.
2.  **`tron.exe`**: A native Windows Executable wrapper that extracts and launches the script.

## How to Build

### 1. Requirements
*   **OS**: Windows 10 or 11.
*   **Runtime**: PowerShell 5.1 (Pre-installed on Windows).
*   **Compiler**: Microsoft .NET Framework (`csc.exe`) - typically pre-installed.

### 2. Execution
Run the build script located in `tronsrc/build/`.

```powershell
# From the Repository Root
powershell -ExecutionPolicy Bypass -File .\tronsrc\build\build.ps1
```

## How the Build Works

1.  **Concatenation**: `build.ps1` reads all files in `tronsrc/src/` (Core, Utils, Stages).
2.  **Embedding**: It reads `tronsrc/config/*.json` and embeds them as strings into the script.
3.  **Injection**: It assembles a `Main Controller` block to orchestrate execution.
4.  **C# Wrapping** (for EXE):
    *   It takes the final `tron.ps1` content and Base64 encodes it.
    *   It generates a temporary C# source file (`tron_wrapper.cs`) containing the Base64 blob.
    *   It invokes the native C# compiler (`csc.exe`) found in `%WINDIR%\Microsoft.NET\Framework64\` to produce `tron.exe`.

## Troubleshooting

*   **"csc.exe not found"**: Ensure you have .NET Framework installed (standard on Windows). The build script looks in standard paths.
*   **"ExecutionPolicy"**: You must run with `-ExecutionPolicy Bypass` to allow the build script to run.
