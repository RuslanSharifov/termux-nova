# ✦ TERMUX NOVA — Setup / Quraşdırma / Kurulum

**One simple install, then detailed help in your language.**

## 🤖 Android Termux — copy once

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

Read the installer questions and choose whether to disable other UI tools and enable automatic theme restore.

## 🖥️ Windows CMD — download and double-click

1. **[Download the ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip).**
2. Extract `termux-nova-main`.
3. Open `termux-nova-main/windows`.
4. **Double-click `install.cmd`**, follow the prompt and then open a new CMD window.

⚠️ The Windows installer may overwrite an existing CMD AutoRun registry value. Back up existing CMD startup settings first; see the Windows guides below.

## 🌍 Language guides

| Language | Android Termux | Windows CMD |
|---|---|---|
| 🇦🇿 Azərbaycan | [Termux](docs/termux/SETUP.az.md) | [Windows CMD](docs/cmd/SETUP.az.md) |
| 🇬🇧 English | [Termux](docs/termux/SETUP.en.md) | [Windows CMD](docs/cmd/SETUP.en.md) |
| 🇹🇷 Türkçe | [Termux](docs/termux/SETUP.tr.md) | [Windows CMD](docs/cmd/SETUP.tr.md) |
| 🇷🇺 Русский | [Termux](docs/termux/SETUP.ru.md) | [Windows CMD](docs/cmd/SETUP.ru.md) |
| 🇩🇪 Deutsch | [Termux](docs/termux/SETUP.de.md) | [Windows CMD](docs/cmd/SETUP.de.md) |
| 🇫🇷 Français | [Termux](docs/termux/SETUP.fr.md) | [Windows CMD](docs/cmd/SETUP.fr.md) |

All language guides put installation first, then show how to use `nova console`, switch themes, manage custom commands, update and uninstall.

[README and combined demo](README.md) · **rugo / Ruslan Sharifov**
