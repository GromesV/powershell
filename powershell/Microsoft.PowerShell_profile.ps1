


# Terminal Icons
Import-Module -Name Terminal-Icons

Remove-Item Alias:ls  -Force -ErrorAction SilentlyContinue
Remove-Item Alias:dir -Force -ErrorAction SilentlyContinue

function ls
{ eza --long --icons=auto          @args 
}
function ll
{ eza --long --icons=auto --all    @args 
}
function la
{ eza --icons=auto --all           @args 
}
function dir
{ eza --long --icons=auto          @args 
}
function dirs
{ eza --long --icons=auto          @args 
}






# ============================================================
#  NAVIGATION
# ============================================================


# for tui install Install-Module -Name Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser -Force

function gt-pajtoni
{
    param([string]$Name)

    $BasePath = "D:/programiranje/pajtoni"

    # Get all matching folders
    $matchess = Get-ChildItem -Path $BasePath -Directory |
        Where-Object { $_.Name -like "*$Name*" }

    if ($matchess.Count -eq 0)
    {
        Write-Warning "No project found containing '$Name'"
    } elseif ($matchess.Count -eq 1)
    {
        Set-Location $matchess.FullName
    } else
    {
        # This creates the terminal-based dropdown
        $selection = $matchess |
            Select-Object Name, FullName |
            Out-ConsoleGridView -Title "Select Project" -OutputMode Single

        if ($selection)
        {
            Set-Location $selection.FullName
        }
    }
}

function gt-desktop
{ Set-Location "C:\Users\VladimirGromes\Desktop"
}
function gt-onedrive
{ Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC"
}
function gt-projects
{ Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\projects"
}
function gt-dev
{ Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\dev"
}
function gt-git
{ Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\dev\git"
}
function gt-decipher
{ Set-Location "C:\Users\VladimirGromes\OneDrive - Quadrant Strategies LLC\Work\decipher"
}


# open with n++
function npp
{ & "C:\Program Files (x86)\Notepad++\notepad++.exe" @args
}

# Linux-style touch — creates file if it doesn't exist, updates timestamp if it does
function touch ($file)
{
    if (Test-Path $file)
    { (Get-Item $file).LastWriteTime = Get-Date
    } else
    { New-Item -ItemType File -Path $file | Out-Null
    }
}

# which — find where a command/executable lives
function which ($cmd)
{
    Get-Command $cmd -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

# grep — search text in files or piped input
function grep ($pattern, $path)
{
    if ($path)
    { Get-ChildItem $path -Recurse -File | Select-String -Pattern $pattern
    } else
    { $input | Select-String -Pattern $pattern
    }
}

# findtext — recursive content search from current dir
function findtext ($text)
{
    Get-ChildItem -Recurse -File | Select-String -Pattern $text
}

# here — open current folder in Explorer
function here
{ explorer .
}

# editconf — open profile in Notepad
function editconf
{ code $PROFILE
}

# reload — re-source profile without restarting terminal
function reload
{
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
#  PROMPT COLORS (Optimized for Quiet Light Theme)
# =============================================================================

$C_USER  = "$ESC[38;5;126m"   # Deep Magenta (Darker than Pink)
$C_AT    = "$ESC[38;5;240m"   # Dark Charcoal Grey
$C_HOST  = "$ESC[38;5;24m"    # Deep Navy/Steel Blue (Replaces Cyan)
$C_PATH  = "$ESC[38;5;28m"    # Forest Green (Replaces Lime Green)
$C_GIT   = "$ESC[38;5;130m"   # Burnt Orange/Brown (Replaces Amber)
$C_OK    = "$ESC[38;5;22m"    # Dark Emerald Green (Replaces Bright Green)
$C_FAIL  = "$ESC[38;5;124m"   # Deep Crimson (Replaces Bright Red)
$C_TIME  = "$ESC[38;5;242m"   # Medium-Dark Grey

# =============================================================================
#  HELPER: Get-GitBranch
#  Returns the current git branch name with color formatting,
#  or an empty string if the current folder is not a git repository.
#  Errors are silently ignored (git not installed, not a repo, etc.)
# =============================================================================

function Get-GitBranch
{
    try
    {
        # Ask git for the current branch name. 2>$null hides error output.
        $branch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($branch)
        {
            # Returns:  " on <branchname>"  styled with colors
            return " $ESC[38;5;239mon$RESET $C_GIT$branch$RESET"
        }
    } catch
    {
    }
    return ""   # not a git repo — return nothing, prompt stays clean
}


# =============================================================================
#  HELPER: Get-ShortPath
#  Returns the current directory with $HOME replaced by ~
#  and backslashes converted to forward slashes.
#
#  Example:  C:\Users\Vlada\Documents\code  →  ~/Documents/code
# =============================================================================

function Get-ShortPath
{
    $p = $PWD.Path
    if ($p.StartsWith($HOME))
    {
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

function prompt
{
    # $? must be captured on the VERY FIRST LINE — any other statement resets it
    $lastOk = $?

    # Gather all pieces of the prompt
    $user  = if ($env:USERNAME)
    { $env:USERNAME
    } else
    { $env:USER
    }       # works on Windows and Unix
    $hname = if ($env:COMPUTERNAME)
    { $env:COMPUTERNAME
    } else
    { hostname
    } # works on Windows and Unix
    $path  = Get-ShortPath
    $git   = Get-GitBranch
    $time  = Get-Date -Format "HH:mm:ss"

    # Assemble line 1: each segment is <color><text><reset>
    $line1 = "${C_PATH}${path}${RESET}${git}  ${C_TIME}${time}${RESET}"

    # >> symbol: green on success, red on failure
    $symbol = if ($lastOk)
    { "${C_OK}`$${RESET}"
    } else
    { "${C_FAIL}`$${RESET}"
    }

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

if ($prl)
{
    $prlVersion = $prl.Version

    # Windows editing mode: Home/End/Ctrl+Left/Right work as expected
    Set-PSReadLineOption -EditMode Windows



    # History prediction — requires PSReadLine 2.1+
    # Suggests completions based on previously typed commands
    if ($prlVersion -ge [Version]"2.1.0")
    {
        Set-PSReadLineOption -PredictionSource History

        # ListView style + dim inline color — requires PSReadLine 2.2+
        if ($prlVersion -ge [Version]"2.2.0")
        {
            try
            {
                Set-PSReadLineOption -PredictionViewStyle ListView
                Set-PSReadLineOption -Colors @{ InlinePrediction = "`e[38;5;238m" }   # dim grey
            } catch
            {
            }
        }
    }

    # Ctrl+D exits PowerShell (equivalent to typing 'exit')
    Set-PSReadLineKeyHandler -Key "Ctrl+d" -Function DeleteCharOrExit
}



# powershell# Set your API key once per session (or add to your profile)
# $env:SURVEY_API_KEY = "your_api_key_here"

# # Run the function
# Get-SurveyData -Server "your.server.com" -Survey "12345"
# Key points:

# API key is read from $env:SURVEY_API_KEY — set it once and reuse
# -Server should be just the hostname (no https://), the function builds the full URL
# The extracted file is found by matching any file named {survey}.* (excluding .zip) after extraction
# Excel is opened via Start-Process so the script doesn't block

# simple vscode task example
function Get-SurveyData
{
    param(

        # FIXME: this should be hardcoded and its always decipher inc bla bla
        [Parameter(Mandatory=$true)]
        [string]$Server,
        # FIXME: this should come from the parsed json. so from the location where this script is called we go up then to .vscode, then read settings json and obtain key decipherPath
        # ../.vscode/settings.json -> read that as json and get value of decihpreProject key
        [Parameter(Mandatory=$true)]
        [string]$Survey
        # FIXME: also i want to pass the statuses. so in the task i should have options such as qualified, terminated, all
    )

    # FIXME: Read API key from environment variable, check the real name of the variable
    $ApiKey = $env:SURVEY_API_KEY
    if (-not $ApiKey)
    {
        Write-Host "Error: SURVEY_API_KEY environment variable is not set." -ForegroundColor Red
        return
    }

    $Url = "https://$Server/api/v1/surveys/$Survey/data?format=json"
    $ZipFile = "$Survey.zip"
    $OutputDir = Split-Path -Parent $ZipFile
    if (-not $OutputDir)
    { $OutputDir = "."
    }

    Write-Host "Fetching survey data from: $Url" -ForegroundColor Cyan

    # Download the zip file
    try
    {
        Invoke-WebRequest -Uri $Url -Headers @{ "x-apikey" = $ApiKey } -Method GET -OutFile $ZipFile
        Write-Host "Downloaded: $ZipFile" -ForegroundColor Green
    } catch
    {
        Write-Host "Error downloading data: $_" -ForegroundColor Red
        return
    }

    # Unzip the file
    try
    {
        Expand-Archive -Path $ZipFile -DestinationPath $OutputDir -Force
        Write-Host "Unzipped to: $OutputDir" -ForegroundColor Green
    } catch
    {
        Write-Host "Error unzipping file: $_" -ForegroundColor Red
        return
    }

    # Delete the zip file
    Remove-Item -Path $ZipFile -Force
    Write-Host "Deleted zip: $ZipFile" -ForegroundColor Yellow

    # Open the extracted file in Excel (assumes extracted file matches survey name)
    $ExtractedFile = Get-ChildItem -Path $OutputDir | Where-Object { $_.Name -like "$Survey.*" -and $_.Extension -ne ".zip" } | Select-Object -First 1
    if ($ExtractedFile)
    {
        Write-Host "Opening in Excel: $($ExtractedFile.FullName)" -ForegroundColor Cyan
        Start-Process excel.exe $ExtractedFile.FullName
    } else
    {
        Write-Host "Warning: Could not find extracted file matching survey '$Survey'." -ForegroundColor Yellow
    }

    Confirm-Task
}



# =============================================================================
#  STARTUP MESSAGE
#  Shown once when the terminal opens and the profile loads.
#  Remove or edit this line if you don't want it.
# =============================================================================
Invoke-Expression (& { (zoxide init powershell | Out-String) })
# Fix: manually fire zoxide hook on every prompt
$global:__zoxide_prompt_old2 = $function:prompt
function global:prompt
{
    $result = & $global:__zoxide_prompt_old2
    $null = __zoxide_hook
    return $result
}

# scoop install fd

Set-PSReadLineKeyHandler -Key "Ctrl+f" -ScriptBlock {
    $selected = fd --type d --hidden --exclude .git --exclude node_modules --exclude __pycache__ --exclude .venv --exclude venv --exclude dist --exclude build --exclude .next --exclude target |
        fzf --height 40% --border --prompt "cd > "
    if ($selected)
    {
        Set-Location $selected
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

Set-PSReadLineKeyHandler -Key "Ctrl+m" -ScriptBlock {
    $selected = fd --type f --search-path "$env:USERPROFILE\Desktop" --search-path "$env:USERPROFILE\Downloads" |
        fzf --height 40% --border --prompt "move > " --multi
    if ($selected)
    {
        $selected | ForEach-Object { Move-Item $_ . }
        Write-Host "Moved $($selected.Count) file(s) here" -ForegroundColor DarkGreen
    }
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

Set-PSReadLineKeyHandler -Key "Ctrl+u" -ScriptBlock {
    $parents = @()
    $current = Get-Item (Get-Location)
    while ($current.Parent) {
        $current = $current.Parent
        $parents += $current.FullName
    }
    $selected = $parents | fzf --height 40% --border --prompt "up > "
    if ($selected) {
        Set-Location $selected
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}


function weather
{ curl "wttr.in/?format=v2" 
}
