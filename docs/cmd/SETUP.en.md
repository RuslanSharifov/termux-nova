# Termux Nova — Windows CMD setup

[← Main README and demo](../../README.md) · [Android Termux guide](../termux/SETUP.en.md)

## 1. Install — download ZIP and double-click install.cmd

**You don't need to copy any installation commands on Windows.** Follow these 4 steps:

1. **[Download the termux-nova ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. Extract the ZIP archive (Extract All).
3. Open `termux-nova-main`, then the `windows` folder.
4. **Double-click `install.cmd`**, answer the installer prompts, then **open a new CMD window**.

**Important:** If you already use CMD startup scripts, back up AutoRun before step 4. Nova may overwrite `HKCU\Software\Microsoft\Command Processor\AutoRun`. Optional backup instructions are below.

The installer uses PowerShell to copy Nova into your user profile and add it to PATH. Windows Terminal is recommended for color schemes. Use a **Command Prompt (CMD) profile**, not PowerShell, to get `doskey` shortcut macros.

## 2. How to use Nova

In a fresh CMD window type `nova console`. Navigate with arrow keys and Enter, or a number followed by Enter.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Themes and automatic startup

Themes: `nova-dark`, `dracula`, `gruvbox`, `nord`. Colors apply primarily to Windows Terminal. `nova auto on` restores the selected theme on startup. Banner-on-start and after `cls` can be configured in `nova console`.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Custom commands — create, list, edit, delete

`///` separates commands executed in sequence. The example below requires Git for Windows to be installed. After changing shortcuts, **open a new CMD window** to load updated macros.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Update

Download a fresh [GitHub ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip), extract it, run the new `termux-nova-main/windows/install.cmd`, and open a new CMD session. Reinstalling may replace the AutoRun value again.

## 6. Optional: back up CMD AutoRun

Before installing, in CMD you can use these commands to inspect AutoRun and export a backup of the registry key. If the key doesn't exist, the export error is normal. Review the saved `.reg` file before restoring it later.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Troubleshooting

1. **`nova` is not recognized** — open a new CMD, check `where nova` and rerun `install.cmd` if needed.
2. **Theme doesn't change** — use a Windows Terminal Command Prompt profile and run `nova doctor`. Comments in `settings.json` may prevent it from being parsed.
3. **Banner doesn't appear** — run `nova hook` in CMD and reopen the window; `cmd /d` intentionally disables AutoRun.
4. **Custom command doesn't run** — inspect `nova cmd` and open a new CMD window.

## 8. Uninstall and privacy {#uninstall}

First disable automatic restore and inspect AutoRun. **Delete the AutoRun value only if it still belongs to Nova**; otherwise you could break other startup scripts. Then back up and delete `%APPDATA%\termux-nova`, and remove that folder from your user PATH in Windows Environment Variables. You may also delete `%LOCALAPPDATA%\termux-nova` cache.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

To restore Windows Terminal colors, inspect the `settings.json.nova-backup` file; repeated theme changes may have overwritten that backup. Never store passwords or tokens in custom command definitions.

**Scope:** This version integrates with Windows CMD / Windows Terminal; it does not modify the native Android application UI.

---

Made by **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
