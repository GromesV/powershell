# PowerShell 7 Profile

Custom PowerShell 7 prompt with fuzzy navigation, eza directory listing, and productivity utilities.

---

## Requirements

- **PowerShell 7** — download from https://github.com/PowerShell/PowerShell/releases/latest
  Pick the `PowerShell-7.x.x-win-x64.msi` file and run it.
- **Windows Terminal** — get it from the Microsoft Store if you don't have it.
- **Scoop** — package manager used to install CLI tools: https://scoop.sh
- **eza** — modern replacement for `ls/dir`
- **fd** — fast file finder, respects `.gitignore`
- **fzf** — fuzzy finder for interactive file/folder picking

---

## Installing dependencies

```powershell
# Install scoop (if not already installed)
irm get.scoop.sh | iex

# Install CLI tools
scoop install eza fd fzf
```

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

## What's in the profile

### Directory listing (eza)
The built-in `ls` and `dir` are replaced with `eza` for a cleaner output.

| Command | What it does |
|---------|-------------|
| `ls`    | Long listing |
| `ll`    | Long listing including hidden files |
| `la`    | All files, short listing |
| `dir`   | Same as `ls` |

### Navigation shortcuts

| Command | Jumps to |
|---------|----------|
| `gt-desktop`  | Desktop |
| `gt-onedrive` | OneDrive root |
| `gt-projects` | Work projects folder |
| `gt-dev`      | Dev folder |
| `gt-git`      | Git folder |
| `gt-decipher` | Decipher folder |
| `gt-pajtoni [name]` | Fuzzy-picks a project under `D:\programiranje\pajtoni` |

### Fuzzy keybindings (fzf + fd)

| Keybind | What it does |
|---------|-------------|
| `Ctrl+F` | Fuzzy pick a subfolder and `cd` into it (skips `node_modules`, `__pycache__`, `.git`, etc.) |
| `Ctrl+M` | Fuzzy pick files from Desktop and Downloads and move them to current folder. `Tab` to select multiple. |

### Utility functions

| Command | What it does |
|---------|-------------|
| `touch <file>` | Creates a file, or updates its timestamp if it exists |
| `which <cmd>`  | Shows the full path to a command/executable |
| `grep <pattern> [path]` | Searches text in files or piped input |
| `findtext <text>` | Recursive content search from current directory |
| `here`    | Opens current folder in Explorer |
| `npp <file>` | Opens file in Notepad++ |
| `editconf` | Opens the profile in VS Code |
| `reload`   | Re-sources the profile without restarting the terminal |

### fd ignore rules
Create a `.fdignore` file in your home directory to permanently exclude noisy folders from `fd` (and therefore `Ctrl+F`/`Ctrl+M`):

```
node_modules
__pycache__
.venv
venv
dist
build
.next
target
.git
```

---

## Making changes to the profile

| What | How |
|------|-----|
| Edit the profile | `editconf` or `code $PROFILE` |
| Reload after editing | `reload` or `. $PROFILE` |
| See where profile lives | `echo $PROFILE` |
| Change prompt colors | Edit the `$C_PATH`, `$C_GIT`, `$C_OK` etc. variables |

---

## PowerShell 7 in VS Code terminal

**Step 1:** Find the actual path:
```powershell
where.exe pwsh
```

**Step 2:** Add this to your VS Code `settings.json`:

```json
"terminal.integrated.profiles.windows": {
    "PowerShell": {
        "path": "C:\\Program Files\\PowerShell\\7\\pwsh.exe",
        "icon": "terminal-powershell",
        "args": ["-ExecutionPolicy", "Bypass"]
    }
},
"terminal.integrated.defaultProfile.windows": "PowerShell"
```