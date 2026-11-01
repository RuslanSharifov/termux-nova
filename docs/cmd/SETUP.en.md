# Complete Windows CMD installation guide

> **Termux Nova v2.x** · **EN** · [Termux Android](../termux/SETUP.en.md) · [Documentation index](../README.md)

This guide covers the **Windows version** running in `cmd.exe` or a Windows Terminal Command Prompt profile. For Android, use the [Termux guide](../termux/SETUP.en.md). Windows uses `windows/install.cmd` — `pkg` is not a Windows command.

## Requirements / 01

Windows 10 or 11, included Windows PowerShell 5.1, Git (or a ZIP download), and optionally Windows Terminal for color schemes. Administrator privileges are generally not needed. If `winget` is unavailable, install Git for Windows from its official installer or use the ZIP method.

## 02 — Prepare Command Prompt

**1. Prepare Windows CMD.** Open Command Prompt from Start or Windows Terminal → Command Prompt. Install Git for Windows using `winget` if available; otherwise use the ZIP workflow. Open a **new CMD window** after installing Git.

```cmd
winget install --id Git.Git -e
```

Check Git in a **new** CMD window:

```cmd
git --version
where git
```

Optional Windows Terminal install (if `winget` is present):

```cmd
winget install --id Microsoft.WindowsTerminal -e
```

## 03 — Download or clone from GitHub

**2. Clone the repository to your computer.** These commands place the project in Downloads. `cd /d` changes both the drive and directory. `dir` should show `install.cmd`, `install.ps1`, and `nova.ps1`.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Alternative: ZIP without Git.** Open the link in your browser, extract the ZIP into Downloads and enter the extracted project's `windows` folder. Adjust the directory if you chose a different extraction location.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. Inspect and back up CMD AutoRun before installation.** For startup banners and `doskey` macros, Nova sets the current-user registry value `HKCU\Software\Microsoft\Command Processor\AutoRun`. **It can overwrite an existing AutoRun value**. Check with `reg query` and export the key if it exists. An export error for a nonexistent key is expected on a clean setup.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Run the Windows installer.** Execute `install.cmd` from the `windows` directory. It starts Windows PowerShell 5.1 with a process-scoped `-ExecutionPolicy Bypass`; it does not permanently change the machine policy.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

The installer copies `nova.ps1`, `nova.cmd`, and `themes.json` into `%APPDATA%\termux-nova`, adds that folder to your user `PATH`, sets CMD AutoRun hooks, asks about auto restore (**Enter = yes**), and attempts to apply `nova-dark` in Windows Terminal. **Open a fresh CMD window after installing** to load the updated PATH and AutoRun.

## 06 — Verify and open console

**5. Verify and open settings.** `where nova` shows the installed launcher's path. `nova console` supports Up/Down and Enter or number + Enter. `nova doctor` reports diagnostics.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Themes and CMD behavior.** `nova set dracula` edits the color scheme in Windows Terminal `settings.json`; classic Command Prompt may not show the same visual result. Select a **Command Prompt** profile in Windows Terminal: CMD macros do not work inside a PowerShell profile. Banner-on-start and banner-after-`cls` are controlled in `nova console`.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
nova hook
```

## 08 — Custom commands: create / read / edit / delete

**7. Create, edit, and remove custom commands.** `///` separates sequential steps. The Git example requires Git; the optional npm example requires Node.js/npm installed separately. Open a fresh CMD window after editing macros.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
nova cache clear
```

Optional example for projects with Node.js/npm already installed:

```cmd
nova cmd add "npm run full" "npm install /// npm run dev"
nova cmd
```

## 09 — Update an existing Git clone

**8. Update.** For a Git clone, use `git pull --ff-only`, then rerun `install.cmd`. For ZIP installs, download the latest archive again and reinstall from its updated `windows` folder.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — open a new CMD window, run `where nova`, and rerun `install.cmd` if needed.
2. Colors do not change — use Windows Terminal and run `nova doctor`. Comments in `settings.json` may prevent the script from parsing it.
3. No banner — use a CMD profile, run `nova hook`, then open a new window. `cmd /d` deliberately bypasses AutoRun.
4. `cls` macro does not work — rerun `nova hook` and start a new CMD session; `doskey` hooks do not apply to PowerShell profiles.
5. Your old CMD AutoRun disappeared — review your preinstall `.reg` backup; back up the current registry state before restoring.

## 11 — Uninstall and privacy

**9. Uninstall.** This release has no dedicated Windows uninstaller. First run `nova auto off`. Check with `reg query` that AutoRun still belongs to Nova before deleting it, or restore your original registry backup. The `%APPDATA%\termux-nova` directory contains custom commands — back it up before deletion. Remove that directory from your user PATH using Windows *Environment Variables*. To restore Windows Terminal colors, inspect `settings.json.nova-backup`; note that changing themes repeatedly may overwrite this backup.

Run the first command in CMD. **Only delete AutoRun if it contains Nova's hook and you have a backup of any previous value.**

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun /f
```

**Optional, irreversible removal of the installed tool and user data** (after exporting any custom commands you need):

```cmd
rmdir /s /q "%APPDATA%\termux-nova"
rmdir /s /q "%LOCALAPPDATA%\termux-nova"
```

Custom commands are stored in `%APPDATA%\termux-nova\commands`; do not include secret tokens. Review registry and Windows Terminal settings changes before installation.

---

**Author:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [All languages and platforms](../README.md).
