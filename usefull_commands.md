# clipboard to json

Clipboard content to file.
`gcb > data.json`


Get current path to clipboard. 
`gl|scb`

Get info for Alias.
`alias gl`

Save filen in folder to txt.file.
`(gci).Name > dir.txt`

Open file in default opener program, lets say for xlsx it will be ecxel, for txt n++

`ii filename.txt`


### Common Two-Letter Collisions
If every "Get-C..." command used only two letters, the system would run out of unique shortcuts almost immediately. Here is how PowerShell differentiates other similar commands:

| Full Command | Alias | Logic |
| :--- | :--- | :--- |
| `Get-Command` | **`gcm`** | **G**et **C**om**m**and |
| `Get-Content` | **`gc`** | **G**et **C**ontent |
| `Get-ChildItem` | **`gci`** | **G**et **C**hild**I**tem |
| `Get-Credential` | **`gcred`** | **G**et **Cred**ential |
| `Get-Culture` | **`gcul`** | **G**et **Cul**ture |

---

### Discovering the "Why" on Your Own
If you ever run into an alias that doesn't make sense, you can reverse-engineer it using `Get-Alias`. Since you're likely moving between different environments, you can run this to see the pattern:

```powershell
Get-Alias gc, gcb, gci | Select-Object Name, Definition
```

### Pro-Tip: Ambiguity in Naming
PowerShell's built-in aliases were designed to avoid "clobbering" (overwriting) each other. If `Get-Clipboard` had taken `gc`, then `Get-Content`—which is arguably used much more frequently in automation—would have needed a longer, less convenient alias. 

By using **`gcb`**, the shell stays predictable: `gc` is for the file system (Content), and `gcb` is for the Clipboard.