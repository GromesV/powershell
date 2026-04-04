# PowerShell 7 Profile

Colorful PowerShell 7 prompt and directory listing. No third-party tools required.

---

## Requirements

- **PowerShell 7** — download from https://github.com/PowerShell/PowerShell/releases/latest
  Pick the `PowerShell-7.x.x-win-x64.msi` file and run it.
- **Windows Terminal** — get it from the Microsoft Store if you don't have it.

---

## Installation

**1. Copy the profile to the right place:**
```powershell
Copy-Item "D:\programiranje\powershell\Microsoft.PowerShell_profile.ps1" $PROFILE -Force
```

**2. Unblock it (Windows flags downloaded files as unsafe):**
```powershell
Unblock-File $PROFILE
```

**3. Reload without restarting the terminal:**
```powershell
. $PROFILE
```

---

## Setting up Windows Terminal to use PowerShell 7

By default Windows Terminal opens the old PowerShell 5. To switch to PS7:

1. Open Windows Terminal settings: `Ctrl+,`
2. Click **Add a new profile** (or find the existing PowerShell entry)
3. Set the **Command line** to:
   ```
   pwsh.exe
   ```
4. Go to **Startup** and set this profile as the **Default profile**
5. Save

After this, every new terminal window opens PS7 automatically.

---

## Restoring Windows Terminal appearance (Gruvbox 77 theme, fonts, etc.)

All Windows Terminal settings live in a single JSON file:
```
%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
```

To restore your look on a new machine, just copy your backed-up `settings.json` to that path.

---

## Making changes to the profile

| What                        | How                                              |
|-----------------------------|--------------------------------------------------|
| Edit the profile            | `notepad $PROFILE`                               |
| Reload after editing        | `. $PROFILE`                                     |
| See where profile lives     | `echo $PROFILE`                                  |
| Change prompt colors        | Edit the `$C_USER`, `$C_PATH` etc. variables     |
| Change folder color in dir  | Edit `$C_DIR` RGB values in `Write-ColorDir`     |
| Test a color without saving | See the test command inside the profile comments |

## POWERSHELL 7 in terminal VSCODE


Step 1: Find the actual path
Run this command in your current VS Code terminal:

PowerShell
`where.exe pwsh`

Add this to settings.json for vscode.


```json

"terminal.integrated.profiles.windows": {
        "PowerShell": {
            "path": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
            "icon": "terminal-powershell",
            "args": ["-ExecutionPolicy", "Bypass"]
        }
    },
    "terminal.integrated.defaultProfile.windows": "PowerShell",

```