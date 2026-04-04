# ============================================================
#  NAVIGATION
# ============================================================


# for tui install Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force

function gt-pajtoni {
    param([string]$Name)

    $BasePath = "D:/programiranje/pajtoni"

    # Get all matching folders
    $matches = Get-ChildItem -Path $BasePath -Directory | 
               Where-Object { $_.Name -like "*$Name*" }

    if ($matches.Count -eq 0) {
        Write-Warning "No project found containing '$Name'"
    } 
    elseif ($matches.Count -eq 1) {
        Set-Location $matches.FullName
    } 
    else {
        # This creates the terminal-based dropdown
        $selection = $matches | 
                     Select-Object Name, FullName | 
                     Out-ConsoleGridView -Title "Select Project" -OutputMode Single
        
        if ($selection) {
            Set-Location $selection.FullName
        }
    }
}

function gt-desktop   { Set-Location "C:\Users\VladimirGromes\Desktop" }
function gt-onedrive  { Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC" }
function gt-projects  { Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\projects" }
function gt-dev       { Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\dev" }
function gt-git       { Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\dev\git" }
function gt-decipher  { Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\decipher" }


# open with n++
function npp { & "C:\Program Files\Notepad++\notepad++.exe" @args }

# Linux-style touch — creates file if it doesn't exist, updates timestamp if it does
function touch ($file) {
    if (Test-Path $file) { (Get-Item $file).LastWriteTime = Get-Date }
    else                 { New-Item -ItemType File -Path $file | Out-Null }
}

# which — find where a command/executable lives
function which ($cmd) {
    Get-Command $cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

# grep — search text in files or piped input
function grep ($pattern, $path) {
    if ($path) { Get-ChildItem $path -Recurse -File | Select-String -Pattern $pattern }
    else       { $input | Select-String -Pattern $pattern }
}

# findtext — recursive content search from current dir
function findtext ($text) {
    Get-ChildItem -Recurse -File | Select-String -Pattern $text
}

# here — open current folder in Explorer
function here { explorer . }

# editconf — open profile in Notepad
function editconf { notepad $PROFILE }

# reload — re-source profile without restarting terminal
function reload {
    . $PROFILE
    Write-Host "Profile reloaded!" -ForegroundColor DarkGreen
}

# =============================================================================
#  PowerShell 7 Profile — Colorful prompt, no third-party tools required
#  (no Oh My Posh, no modules to install)
#
#  LOCATION: This file should live at the path printed by:  echo $PROFILE
#  Typically: C:\Users\<you>\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
#
#  RELOAD without restarting terminal:  . $PROFILE
#  EDIT this file:                      notepad $PROFILE
# =============================================================================


# =============================================================================
#  ANSI COLOR SYSTEM
# =============================================================================
#
#  Terminal colors work via ANSI escape sequences — special codes the terminal
#  interprets as "change color", "reset", etc.
#
#  $ESC is the escape character (ASCII 27). Every color code starts with it.
#  Format:  $ESC[<code>m
#
#  Two color systems are used in this file:
#
#  1. 256-color palette:  $ESC[38;5;<0-255>m   (foreground)
#                         $ESC[48;5;<0-255>m   (background)
#     These depend on your terminal's color scheme. If you use Gruvbox 77,
#     the palette is remapped — color 23 won't be "dark teal", it'll be
#     whatever Gruvbox mapped it to. Use this to preview all 256 colors:
#     https://www.ditig.com/256-colors-cheat-sheet
#
#  2. True color (RGB):   $ESC[38;2;<R>;<G>;<B>m   (foreground)
#                         $ESC[48;2;<R>;<G>;<B>m   (background)
#     These use raw RGB values and BYPASS the terminal's palette remapping.
#     USE THIS when your color scheme (Gruvbox 77) is remapping 256 colors
#     to unexpected values.
#
#  $RESET ($ESC[0m) clears all color/style back to terminal default.
#
#  TO TEST A COLOR LIVE without saving to the profile, run:
#    $ESC = [char]27
#    Write-Host "${ESC}[38;2;235;219;178m${ESC}[48;2;56;98;83m testfolder ${ESC}[0m"
# =============================================================================

$ESC   = [char]27        # ESC character — starts every ANSI sequence
$RESET = "$ESC[0m"       # resets all colors and styles back to terminal default


# =============================================================================
#  PROMPT COLORS
#  These control the two-line prompt shown before every command.
#  All use 256-color palette (38;5;N = foreground text color).
#
#  TO CHANGE: swap the number N in 38;5;N
#  TO PREVIEW: https://www.ditig.com/256-colors-cheat-sheet
# =============================================================================

$C_USER  = "$ESC[38;5;213m"   # pink/violet  — your username
$C_AT    = "$ESC[38;5;244m"   # grey         — the @ symbol between user and host
$C_HOST  = "$ESC[38;5;81m"    # cyan-blue    — your computer name
$C_PATH  = "$ESC[38;5;149m"   # lime green   — current directory path
$C_GIT   = "$ESC[38;5;221m"   # amber        — git branch name
$C_OK    = "$ESC[38;5;82m"    # bright green — >> prompt symbol when last command succeeded
$C_FAIL  = "$ESC[38;5;196m"   # red          — >> prompt symbol when last command failed
$C_TIME  = "$ESC[38;5;244m"   # grey         — timestamp (HH:mm:ss)


# =============================================================================
#  HELPER: Get-GitBranch
#  Returns the current git branch name with color formatting,
#  or an empty string if the current folder is not a git repository.
#  Errors are silently ignored (git not installed, not a repo, etc.)
# =============================================================================

function Get-GitBranch {
    try {
        # Ask git for the current branch name. 2>$null hides error output.
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch) {
            # Returns:  " on <branchname>"  styled with colors
            return " $ESC[38;5;239mon$RESET $C_GIT$branch$RESET"
        }
    } catch {}
    return ""   # not a git repo — return nothing, prompt stays clean
}


# =============================================================================
#  HELPER: Get-ShortPath
#  Returns the current directory with $HOME replaced by ~
#  and backslashes converted to forward slashes.
#
#  Example:  C:\Users\Vlada\Documents\code  →  ~/Documents/code
# =============================================================================

function Get-ShortPath {
    $p = $PWD.Path
    if ($p.StartsWith($HOME)) {
        $p = "~" + $p.Substring($HOME.Length)
    }
    $p -replace '\\', '/'   # convert Windows backslashes to forward slashes
}


# =============================================================================
#  THE PROMPT FUNCTION
#  PowerShell calls prompt{} automatically before every command.
#  It produces a two-line prompt:
#
#  Line 1:  Vlada@WIN-QNS924MJL4N  ~/Documents  on main  03:22:21
#  Line 2:  >>
#           (green >> if the last command succeeded, red >> if it failed)
#
#  TO CHANGE LAYOUT: edit the $line1 string below.
#  TO CHANGE SYMBOL: edit the $symbol line below (currently >>).
# =============================================================================

function prompt {
    # $? must be captured on the VERY FIRST LINE — any other statement resets it
    $lastOk = $?

    # Gather all pieces of the prompt
    $user  = if ($env:USERNAME) { $env:USERNAME } else { $env:USER }       # works on Windows and Unix
    $hname = if ($env:COMPUTERNAME) { $env:COMPUTERNAME } else { hostname } # works on Windows and Unix
    $path  = Get-ShortPath
    $git   = Get-GitBranch
    $time  = Get-Date -Format "HH:mm:ss"

    # Assemble line 1: each segment is <color><text><reset>
    $line1 = "${C_PATH}${path}${RESET}${git}  ${C_TIME}${time}${RESET}"

    # >> symbol: green on success, red on failure
    $symbol = if ($lastOk) { "${C_OK}>>${RESET}" } else { "${C_FAIL}>>${RESET}" }

    Write-Host ""        # blank line above prompt for visual breathing room
    Write-Host $line1    # print line 1 (Write-Host renders ANSI codes correctly)

    # PowerShell requires prompt{} to RETURN a string — this becomes line 2.
    # We return instead of Write-Host so PS places the cursor right after it.
    "$symbol "
}


# =============================================================================
#  ALIASES
#  Shorthand commands. Remove any you don't want.
#
#  which git    →  shows the full path to the git executable
#  touch file   →  creates an empty file (like Unix touch)
#  ll           →  colored directory listing (defined below)
# =============================================================================

Set-Alias which Get-Command
Set-Alias touch New-Item


# =============================================================================
#  COLORED DIRECTORY LISTING  (replaces dir / ls / ll)
#
#  The built-in dir shows: Mode, LastWriteTime, Length, Name
#  This replaces it with:  date  size  name  (no Mode column)
#
#  COLOR LEGEND:
#    Folders  — warm white text on dark teal background
#               Uses TRUE RGB color (48;2;R;G;B) to bypass Gruvbox 77 remapping.
#               The Gruvbox 77 color scheme remaps the 256-color palette, so
#               regular 48;5;N background colors show wrong. RGB bypasses this.
#
#    Files    — gruvbox fg1 warm beige (256-color)
#    Hidden   — dimmed grey (256-color) — dotfiles, system files, etc.
#    Date     — grey (256-color)
#    Size     — gruvbox aqua (256-color); auto-scales to B/K/M/G; blank for folders
#
#  TO CHANGE FOLDER BACKGROUND COLOR (RGB):
#    Edit the 48;2;R;G;B part of $C_DIR.
#    Current: 56;98;83 = dark teal
#    To preview a color before saving:
#      $ESC = [char]27
#      Write-Host "${ESC}[38;2;235;219;178m${ESC}[48;2;56;98;83m testfolder ${ESC}[0m"
#
#  TO CHANGE FILE/HIDDEN COLOR (256-color):
#    Edit the 38;5;N number in $C_FILE or $C_HIDDEN.
# =============================================================================

function Write-ColorDir {
    param([string]$Path = ".")

    $ESC = [char]27

    # TRUE RGB colors — not affected by Gruvbox 77 palette remapping
    # 38;2;R;G;B = foreground,  48;2;R;G;B = background
    $C_DIR    = "$ESC[38;2;235;219;178m$ESC[48;2;56;98;83m"   # warm white text, dark teal background

    # 256-color palette — affected by Gruvbox 77 remapping (fine for these)
    $C_FILE   = "$ESC[38;5;223m"   # gruvbox fg1 warm beige  — regular files
    $C_HIDDEN = "$ESC[38;5;240m"   # gruvbox dark4 grey      — hidden files and folders
    $C_DATE   = "$ESC[38;5;246m"   # gruvbox grey            — date column
    $C_SIZE   = "$ESC[38;5;108m"   # gruvbox aqua            — size column
    $RESET    = "$ESC[0m"

    # -Force includes hidden files and system files in the listing
    $items = Get-ChildItem -Path $Path -Force

    foreach ($item in $items) {
        # Check the Hidden attribute bit using bitwise AND
        $isHidden = $item.Attributes -band [System.IO.FileAttributes]::Hidden
        $isDir    = $item.PSIsContainer   # true = directory, false = file

        # Priority: hidden > directory > file
        $nameColor = if ($isHidden)  { $C_HIDDEN }
                     elseif ($isDir) { $C_DIR }
                     else            { $C_FILE }

        $date = $item.LastWriteTime.ToString("yyyy-MM-dd HH:mm")

        # Size: blank (7 spaces) for directories, human-readable for files
        $size = if ($isDir) { "       " }
                else {
                    $b = $item.Length
                    if     ($b -ge 1GB) { "{0,6:N1}G" -f ($b / 1GB) }
                    elseif ($b -ge 1MB) { "{0,6:N1}M" -f ($b / 1MB) }
                    elseif ($b -ge 1KB) { "{0,6:N1}K" -f ($b / 1KB) }
                    else                { "{0,6}B"    -f $b }
                }

        # Print one row: date  size  name
        Write-Host "$C_DATE$date$RESET  $C_SIZE$size$RESET  $nameColor$($item.Name)$RESET"
    }
}

Remove-Item Alias:ls -Force -ErrorAction SilentlyContinue
function dirs { Write-ColorDir @args }   # dirs → colored listing
function ls   { Write-ColorDir @args }   # ls   → colored listing
Set-Alias ll Write-ColorDir              # ll   → colored listing

Remove-Item Alias:dir -Force -ErrorAction SilentlyContinue
function dir { Write-ColorDir @args }


# =============================================================================
#  PSREADLINE — syntax highlighting + history autocomplete
#
#  PSReadLine handles interactive line editing. It ships built-in with PS7.
#
#  WHAT THIS ENABLES:
#    - Syntax highlighting: commands, strings, variables etc. get different colors
#    - History prediction: as you type, past commands are suggested in dim grey
#    - ListView (PS 2.2+): suggestions appear as a list below the cursor
#    - Ctrl+D: exits the shell like in bash/zsh
#
#  The version checks exist because older PSReadLine versions don't have
#  PredictionSource or PredictionViewStyle — they'd crash without the guards.
#
#  TO CHANGE SYNTAX COLORS:
#    Edit the Colors @{} block. Format: "`e[38;5;N]m" where N is 0-255.
# =============================================================================

$prl = Get-Module -ListAvailable -Name PSReadLine | Sort-Object Version -Descending | Select-Object -First 1

if ($prl) {
    $prlVersion = $prl.Version

    # Windows editing mode: Home/End/Ctrl+Left/Right work as expected
    Set-PSReadLineOption -EditMode Windows

    # Syntax highlighting — works on all PSReadLine versions
    try {
        Set-PSReadLineOption -Colors @{
            Command   = "`e[38;5;81m"    # cyan-blue  — cmdlet names, function names
            Parameter = "`e[38;5;149m"   # lime       — -ParameterName flags
            String    = "`e[38;5;221m"   # amber      — "quoted strings"
            Number    = "`e[38;5;213m"   # pink       — numeric literals (42, 3.14)
            Variable  = "`e[38;5;203m"   # coral      — $variables
            Comment   = "`e[38;5;244m"   # grey       — # comments
            Keyword   = "`e[38;5;141m"   # lavender   — if, foreach, function, return, etc.
            Error     = "`e[38;5;196m"   # red        — syntax errors highlighted live
        }
    } catch {}

    # History prediction — requires PSReadLine 2.1+
    # Suggests completions based on previously typed commands
    if ($prlVersion -ge [Version]"2.1.0") {
        Set-PSReadLineOption -PredictionSource History

        # ListView style + dim inline color — requires PSReadLine 2.2+
        if ($prlVersion -ge [Version]"2.2.0") {
            try {
                Set-PSReadLineOption -PredictionViewStyle ListView
                Set-PSReadLineOption -Colors @{ InlinePrediction = "`e[38;5;238m" }   # dim grey
            } catch {}
        }
    }

    # Ctrl+D exits PowerShell (equivalent to typing 'exit')
    Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit
}


# simple vscode task example
function Confirm-Task {
    Write-Host "---------------------------" -ForegroundColor Cyan
    Write-Host "Task Done!" -ForegroundColor Green
    Write-Host "---------------------------" -ForegroundColor Cyan
}


# =============================================================================
#  STARTUP MESSAGE
#  Shown once when the terminal opens and the profile loads.
#  Remove or edit this line if you don't want it.
# =============================================================================

Write-Host "`e[38;5;213mPowerShell $($PSVersionTable.PSVersion)$RESET  |  type ${C_PATH}help$RESET to get started`n"