Here is your PowerShell "Nuke & Navigate" cheat sheet, organized by function for quick scanning.

---

## 📋 Clipboard & Text
| Task | Command |
| :--- | :--- |
| **Clip to File** | `gcb > data.json` |
| **Path to Clip** | `gl \| scb` or `pwd \| scb` |
| **Clean Clip** | `(gcb).Trim() \| scb` |
| **Search Clip** | `gcb \| sls "search_term"` |

## 📂 File & Directory Management
| Task | Command |
| :--- | :--- |
| **List to File** | `(gci).Name > dir.txt` |
| **Open File** | `ii filename.txt` (Uses default app) |
| **Deep Mkdir** | `mkdir one/two/three` |
| **Folder Size** | `gci -Rec -ErrorAction SilentlyContinue \| measure Length -s \| % { "{0:N2} MB" -f ($_.Sum / 1MB) }` |
| **Top 10 Files** | `gci \| sort length -desc \| select -f 10` |
| **Empty File** | `ni test.txt` |

## 🌲 Smart Recursion (Avoiding `node_modules`)
* **Standard Tree:**
    `tree /f`
* **Selective List (Excluding Junk):**
    `gci -Recurse -Exclude "node_modules", ".git", "dist"`
* **Folders Only:**
    `gci -Directory -Recurse`

## 🛠️ System & Networking
* **Check Alias:**
    `alias gl`
* **Port Check (e.g., 8080):**
    `netstat -ano | findstr :8080`
* **Public IP:**
    `curl ifconfig.me`
* **Tail Log:**
    `gc file.log -Wait`
* **Count Files:**
    `(gci).Count`

## ⚡ Process Control
* **Force Kill by Name:**
    `gps "chrome" | stop-process -f`
* **Short Kill:**
    `kill -n name`
* **Command History:**
    `h | select -last 10`
