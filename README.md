<div align="center">

```text
 ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗
 ████╗  ██║██╔═══██╗██║   ██║██╔══██╗
 ██╔██╗ ██║██║   ██║██║   ██║███████║
 ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║
 ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║
 ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝
```

# ✦ termux-nova

### Termux & Windows Terminal Theme Switcher · Custom Command Manager

**Made by rugo · [RuslanSharifov](https://github.com/RuslanSharifov) · v2.1**

[📖 Detailed setup in 6 languages](docs/README.md) · [⚡ Quick installation](#quick-installation) · [🎛️ Commands](#commands) · [🧩 Custom macros](#custom-command-examples)

</div>

---

## 🌍 Select your language and platform / Dilini və platformanı seç

**Two separate installers — choose the device you actually use.** Termux instructions use Android's `pkg` and Bash. Windows CMD instructions use `install.cmd`, PowerShell and Windows Terminal.

| Language / Dil | 🤖 Android Termux | 🖥️ Windows CMD |
|---|---|---|
| 🇦🇿 Azərbaycanca | [Termux setup](docs/termux/SETUP.az.md) | [Windows CMD setup](docs/cmd/SETUP.az.md) |
| 🇬🇧 English | [Termux setup](docs/termux/SETUP.en.md) | [Windows CMD setup](docs/cmd/SETUP.en.md) |
| 🇹🇷 Türkçe | [Termux setup](docs/termux/SETUP.tr.md) | [Windows CMD setup](docs/cmd/SETUP.tr.md) |
| 🇷🇺 Русский | [Termux setup](docs/termux/SETUP.ru.md) | [Windows CMD setup](docs/cmd/SETUP.ru.md) |
| 🇩🇪 Deutsch | [Termux setup](docs/termux/SETUP.de.md) | [Windows CMD setup](docs/cmd/SETUP.de.md) |
| 🇫🇷 Français | [Termux setup](docs/termux/SETUP.fr.md) | [Windows CMD setup](docs/cmd/SETUP.fr.md) |

> 🇦🇿 **Azərbaycan dilində:** Yuxarıdakı cədvəldən **Termux** və ya **Windows CMD** bölməsini seç, sonra öz dilindəki tam təlimatı aç. Hər birində GitHub-dan yükləmə, quraşdırma, ayarlar, yeniləmə, problem həlli və silmə addımları var.
>
> 🇬🇧 **English:** Pick your platform and language above. Every guide explains download/clone, installation, configuration, update, troubleshooting, uninstall, and data safety.

## ✨ What this project actually does

- **Big NOVA ASCII banner** in the shell and Windows console, with repository information. On Termux it can appear on startup and after `clear`; on CMD after `cls`.
- **Theme switching with a loading animation**. Termux themes are `.properties` files; Windows themes are in `windows/themes.json`.
- **Persistent theme preferences** across sessions after enabling the platform's startup integration (`nova auto on`).
- **Interactive settings console** via `nova console`.
- **Custom command manager (CRUD):** create, list, edit, and delete triggers that execute chained commands.
- **Diagnostics and management:** `nova doctor`, `nova cache clear` and reinstallation of startup integration with `nova hook`.
- **No root needed** for Termux; Windows setup normally works with user permissions.

**Scope:** This is the current Bash/PowerShell **v2.1 codebase rewritten by rugo**, not an earlier Python/Zsh implementation. It does **not** currently implement command-usage counts, SQLite history, ghost-text autocomplete, or single-Tab acceptance. Those features must be built separately if needed.

**Platform differences:** Nova changes the Termux shell/terminal palette or Windows Terminal color scheme and CMD behavior; it does **not** redesign Android's native menus or the Windows desktop UI. CMD macros operate in `cmd.exe`, not PowerShell profiles.

## 🚀 Quick installation

### A — Android Termux

Install a supported Termux app first (official [termux.dev](https://termux.dev/) / F-Droid or GitHub release). Then open Termux:

```bash
pkg update && pkg upgrade -y
pkg install -y git
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
bash install.sh
```

During setup, carefully review the option to disable other prompt/UI tools: the installer comments matching lines in rc files after backing them up. Press **Enter** to enable automatic restoration of the chosen theme, or **n** to turn it off. Start a fresh session or run:

```bash
source ~/.bashrc
nova console
```

[→ Complete Termux setup, Azerbaijani](docs/termux/SETUP.az.md) · [English](docs/termux/SETUP.en.md)

### B — Windows 10/11 Command Prompt (CMD)

Windows needs Git for Windows (or a ZIP download), Windows PowerShell 5.1 and preferably Windows Terminal for color schemes. In **CMD**:

```cmd
winget install --id Git.Git -e
```

Open a **new** CMD after Git installs, then:

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
install.cmd
```

Open another **new** CMD window after installation:

```cmd
where nova
nova console
```

You can also download and extract the [GitHub ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip), open its `windows` folder and double-click `install.cmd`.

**Important:** The Windows installer writes to the current user's `HKCU\Software\Microsoft\Command Processor\AutoRun` value to load CMD macros and the startup banner. This can **replace an existing AutoRun value**. Before installing, run `reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun` and back up the registry key if it exists. The [Windows setup guides](docs/README.md) show the complete backup and uninstall procedure.

[→ Complete Windows CMD setup, Azerbaijani](docs/cmd/SETUP.az.md) · [English](docs/cmd/SETUP.en.md)

## 🎛️ Commands

| Command | Description |
|---|---|
| `nova console` | Interactive settings menu |
| `nova list` | Show available themes and active selection |
| `nova set dracula` | Apply and save a theme |
| `nova current` | Show saved configuration |
| `nova auto on` / `nova auto off` | Enable/disable startup theme restoration |
| `nova banner` | Print the large NOVA banner |
| `nova cmd` | List saved custom commands |
| `nova cmd add "<trigger>" "<steps>"` | Add a custom command |
| `nova cmd edit "<trigger>" "<steps>"` | Edit a command |
| `nova cmd rm "<trigger>"` | Delete a command |
| `nova cache clear` | Clear cache (Termux rebuilds wrappers) |
| `nova hook` | Reinstall platform startup integration |
| `nova doctor` | Diagnose installation |
| `nova help` | Command help |

Termux additionally provides `nova restore` to recover the last installer backup of `~/.bashrc`. **Caution:** It replaces the whole current file, including changes made since that backup.

### Available themes

`nova-dark` · `dracula` · `gruvbox` · `nord`

Termux built-in palette files: [themes/](themes/) · Windows Terminal palette definitions: [windows/themes.json](windows/themes.json).

## 🧩 Custom command examples

The following creates the trigger `npm run full`, running installation before the development script. It works only when Node.js/npm is installed and you are inside a project with a suitable `package.json`:

```bash
nova cmd add "npm run full" "npm install /// npm run dev"
nova cmd
nova cmd edit "npm run full" "npm install /// npm run build"
nova cmd rm "npm run full"
```

Or with Git (provided Git is installed):

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
```

`///` separates sequential steps; later steps run only after the earlier one succeeds. On Termux, reload `~/.bashrc` or open another session after editing commands. On Windows, open a **new CMD** window to refresh doskey macros. Different platforms execute the command steps through their own shell.

**Security:** Custom command definitions can execute arbitrary shell commands. Add only commands you understand. Avoid pasting secrets or access tokens into command definitions.

## 🔄 Updating

**Termux:**

```bash
cd ~/termux-nova
git pull --ff-only
bash install.sh
```

**Windows CMD (assuming the repository is in Downloads):**

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git pull --ff-only
cd windows
install.cmd
```

If Git reports local modifications, save or commit them before pulling. ZIP installations require downloading the newer archive manually.

## 🛠️ Files and configuration

```text
termux-nova/
├── README.md
├── SETUP.md                    ← language/platform entrypoint
├── install.sh                  ← Android Termux installer (Bash)
├── nova.sh                     ← Android Termux CLI
├── themes/                     ← Termux color schemes
├── windows/
│   ├── install.cmd             ← Windows CMD launcher
│   ├── install.ps1             ← Windows installer
│   ├── nova.cmd                ← Windows CLI launcher
│   ├── nova.ps1                ← Windows command manager
│   └── themes.json             ← Windows Terminal color schemes
└── docs/
    ├── README.md               ← language/platform chooser
    ├── termux/                 ← detailed guides: AZ / EN / TR / RU / DE / FR
    └── cmd/                    ← detailed guides: AZ / EN / TR / RU / DE / FR
```

- **Termux settings:** `~/.config/termux-nova`; generated caches: `~/.cache/termux-nova`; startup hooks: `~/.bashrc` and `~/.bash_profile`.
- **Windows settings:** `%APPDATA%\termux-nova`; cache: `%LOCALAPPDATA%\termux-nova\cache`; CMD startup hook: `HKCU\Software\Microsoft\Command Processor\AutoRun`.
- **Windows Terminal:** Nova edits `settings.json` to add/select color schemes. If the file contains JSONC comments, the current script may not parse it. A `settings.json.nova-backup` is written before changing the file; repeated theme changes can overwrite that backup.

## ♻️ Removal and troubleshooting

Follow the **matching platform-specific guide** before removing Nova, especially if you changed your shell startup files or existing CMD AutoRun. The guides describe how to preserve original settings and custom commands.

**Termux:** [AZ](docs/termux/SETUP.az.md) · [EN](docs/termux/SETUP.en.md) · [TR](docs/termux/SETUP.tr.md) · [RU](docs/termux/SETUP.ru.md) · [DE](docs/termux/SETUP.de.md) · [FR](docs/termux/SETUP.fr.md)

**Windows CMD:** [AZ](docs/cmd/SETUP.az.md) · [EN](docs/cmd/SETUP.en.md) · [TR](docs/cmd/SETUP.tr.md) · [RU](docs/cmd/SETUP.ru.md) · [DE](docs/cmd/SETUP.de.md) · [FR](docs/cmd/SETUP.fr.md)

---

<div align="center">

### ✍️ Author / İmza

**rugo · Ruslan Sharifov**  
[github.com/RuslanSharifov](https://github.com/RuslanSharifov)

**TERMUX NOVA** — *Own your terminal.*

</div>
