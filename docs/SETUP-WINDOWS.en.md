# termux-nova for Windows - Setup Guide (English)

by **rugo**

termux-nova on Windows works the same way as on Termux: the same commands, the same settings menu, and the same custom commands (`salam`, `npm run full`, ...). Navigation is done with the arrow keys and Enter, or by typing a number and pressing Enter.

## 1. Requirements

- Windows 10 or 11
- **Windows Terminal** (recommended). Theme switching only works in Windows Terminal. It is included in Windows 11 and can be installed from the Microsoft Store on Windows 10.
- PowerShell 5.1 (already built into Windows)
- Internet for the first install (GitHub statistics and the first download)

## 2. Get the files

Download the repository (or the zip) and open the `windows` folder:

```
termux-nova\windows\
```

## 3. Run the installer

Double-click `install.cmd`, or run this in PowerShell from the `windows` folder:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

The installer:

1. Copies `nova.ps1`, `themes.json` and `nova.cmd` to `%APPDATA%\termux-nova`
2. Adds that folder to your user PATH, so `nova` works in any new window
3. Installs the cmd.exe hooks (banner after `cls`, custom commands, auto restore)
4. Asks whether to enable auto restore (Enter = yes)
5. Applies the default `nova-dark` theme to Windows Terminal

**Open a new Windows Terminal (or cmd) window after installing.**

## 4. Open the settings menu

```
nova console
```

Controls:

| Key | Action |
|---|---|
| ↑ / ↓ | Move the selection |
| Enter | Choose the highlighted item |
| 1 - 9 then Enter | Choose by number |
| Esc | Go back |

## 5. Commands

```
nova list
nova set dracula
nova current
nova auto on
nova auto off
nova banner
nova doctor
```

## 6. Custom commands

Create a command from the menu (`nova console` → Custom commands → Add), or from the command line:

```
nova cmd add "salam" "npm i /// npm run dev"
nova cmd add "npm run full" "npm i /// npm run dev"
nova cmd edit "salam" "npm i /// npm run build"
nova cmd rm "salam"
```

Steps are separated with `///`. Each step runs after the previous one succeeds. Open a new cmd window and type the trigger, for example `salam`.

Note: a trigger cannot contain `///`, and it cannot be a reserved word such as `dir`, `cd`, `cls` or `echo`.

## 7. Startup and clear behaviour

Every new cmd window clears the screen and shows the banner, once. Typing `cls` clears the screen and shows the banner again. Both can be switched off in `nova console`.

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| `nova` is not recognised | Open a new window. If it still fails, run `install.cmd` again |
| Scripts are blocked | Always start them with `-ExecutionPolicy Bypass`, as shown above |
| Theme does not change | Use Windows Terminal, not the old console window. Run `nova doctor` to see where `settings.json` was found |
| Windows Terminal says settings could not be read | Your `settings.json` contains comments. Remove them, or restore `settings.json.nova-backup` |
| Banner does not show after `cls` | Run `nova hook`, then open a new window. Check with `nova doctor` (`cmd AutoRun : ok`) |
| Custom command does not run | Open a new window. Check that `nova cmd` lists the trigger |

## 9. Uninstall

```
nova auto off
```

Then remove the hook and the files:

```powershell
Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Command Processor' -Name AutoRun -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:APPDATA\termux-nova"
```

Remove the `termux-nova` folder from your user PATH in the Windows environment variables settings.

---

Made by **rugo** · MIT License
