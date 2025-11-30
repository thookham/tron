# Script to update archived tag READMEs
# Usage: powershell -ExecutionPolicy Bypass -File update_archived_readmes.ps1

$ErrorActionPreference = "Stop"

# 1. Read Master README content (Template)
$templateHeader = @"
| NAME       | Tron, an automated PC cleanup script                                                        |
| :--------- | :------------------------------------------------------------------------------------------ |
| VERSION    | {VERSION} ({DATE})                                                                          |
| AUTHOR     | vocatus on [old.reddit.com/r/TronScript](https://old.reddit.com/r/tronscript) (`vocatus.gate@gmail`) |
| BACKGROUND | Why the name? Tron "Fights for the User"                                               |

# 🏛️ ARCHIVED RELEASE

> [!WARNING]
> **This is an archived version of Tron (v{VERSION}).**
> It is preserved for historical purposes.
> **Edits powered by Google Gemini Antigravity.**

---

# 📋 CHANGELOG FOR v{VERSION}

{CHANGELOG}

---

# 📖 DESCRIPTION

Tron is an automated script that runs a series of tools to clean, disinfect, and patch a Windows system.

# 🚀 USE

1.  **Download**: Get the release.
2.  **Run**: Right-click `tron.bat` and select "**Run as Administrator**".
3.  **Wait**: The scan can take 3-10 hours.
4.  **Reboot**: Reboot the system when finished.

> [!NOTE]
> This is a legacy version. For the latest features and fixes, please use the latest release.

---

# ⚖️ LICENSE

Tron and any included subscripts and `.reg` files I've written are free to use/redistribute/whatever under the **MIT license**.
"@

# 2. Read Changelog
$changelogPath = "changelog.txt"
if (-not (Test-Path $changelogPath)) {
    Write-Error "changelog.txt not found!"
    exit 1
}
$changelogContent = Get-Content $changelogPath -Raw

# 3. Get Archived Tags
$tags = git tag -n1 | Select-String "Archived Tag"

foreach ($line in $tags) {
    $line = $line.ToString().Trim()
    if ($line -match "^(\S+)\s+Archived Tag: \S+ \(([^)]+)\)") {
        $tagName = $matches[1]
        $tagDate = $matches[2]
        
        Write-Host "Processing $tagName ($tagDate)..." -ForegroundColor Cyan

        # 4. Extract Changelog Entry
        $escapedTagName = [regex]::Escape($tagName)
        $pattern = "(?ms)(^\s*#+\s*#\s*$escapedTagName.*?#+\s*$)(.*?)(?=^\s*#+\s*#\s*v\d|\Z)"
        
        if ($changelogContent -match $pattern) {
            $changelogEntry = $matches[0]
        }
        else {
            $changelogEntry = "No changelog entry found for $tagName."
            Write-Warning "No changelog found for $tagName"
        }

        # 5. Generate README Content
        $newReadme = $templateHeader -replace "{VERSION}", $tagName -replace "{DATE}", $tagDate -replace "{CHANGELOG}", $changelogEntry

        # 6. Checkout, Write, Commit, Retag
        
        # Get commit hash
        $commitHash = git rev-list -n 1 $tagName
        
        Write-Host "  Cleaning..." -ForegroundColor Gray
        # Clean untracked files/directories (excluding this script)
        try {
            Get-ChildItem -Path . -Exclude "update_archived_readmes.ps1", ".git" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
        }
        catch {
            Write-Warning "Cleanup failed: $_"
        }
        git clean -fd -e update_archived_readmes.ps1
        git reset --hard -q
        
        # Checkout with retry
        Write-Host "  Checking out $commitHash..." -ForegroundColor Gray
        git checkout -f -q $commitHash
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Checkout failed for $tagName. Retrying with hard reset..."
            git reset --hard
            git clean -fdx -e update_archived_readmes.ps1
            git checkout -f -q $commitHash
        }
        
        # Write README.md with retry (using temp file and move)
        Write-Host "  Writing README..." -ForegroundColor Gray
        $maxRetries = 5
        $retryCount = 0
        while ($retryCount -lt $maxRetries) {
            try {
                $newReadme | Set-Content "README.temp.md" -Encoding UTF8 -ErrorAction Stop
                Move-Item -Path "README.temp.md" -Destination "README.md" -Force -ErrorAction Stop
                break
            }
            catch {
                $retryCount++
                if ($retryCount -eq $maxRetries) {
                    Write-Error "Failed to write README.md after $maxRetries attempts: $_"
                    throw
                }
                Write-Warning "File locked, retrying in 2s... ($retryCount/$maxRetries)"
                Start-Sleep -Seconds 2
            }
        }
        
        # Add and Commit
        Write-Host "  Committing..." -ForegroundColor Gray
        git add README.md
        git commit -q -m "Update README for $tagName (Archived)"
        
        # Force update the tag
        Write-Host "  Updating tag..." -ForegroundColor Gray
        $annotation = "Archived Tag: $tagName ($tagDate)"
        git tag -f -a $tagName -m "$annotation"
        
        Write-Host "Updated $tagName" -ForegroundColor Green
    }
}

# 7. Return to master
git checkout master
Write-Host "Done. Returned to master." -ForegroundColor Yellow
