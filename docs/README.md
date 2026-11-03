# ✦ Termux Nova — Setup guides in 6 languages

**Custom banner:** After installation, use `nova console` to replace the big NOVA block letters with your own text, or run `nova banner set "HELLO!"`. Use `nova banner reset` to restore the default.


Choose your language and platform. **Installation is at the top of every guide; usage and troubleshooting come afterward.**

| Language | Android Termux | Windows CMD |
|---|---|---|
| 🇦🇿 Azərbaycan | [Termux](termux/SETUP.az.md) | [Windows CMD](cmd/SETUP.az.md) |
| 🇬🇧 English | [Termux](termux/SETUP.en.md) | [Windows CMD](cmd/SETUP.en.md) |
| 🇹🇷 Türkçe | [Termux](termux/SETUP.tr.md) | [Windows CMD](cmd/SETUP.tr.md) |
| 🇷🇺 Русский | [Termux](termux/SETUP.ru.md) | [Windows CMD](cmd/SETUP.ru.md) |
| 🇩🇪 Deutsch | [Termux](termux/SETUP.de.md) | [Windows CMD](cmd/SETUP.de.md) |
| 🇫🇷 Français | [Termux](termux/SETUP.fr.md) | [Windows CMD](cmd/SETUP.fr.md) |

## Quick setup

### Android Termux — one copy/paste

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

### Windows CMD — ZIP + one double-click

1. [Download the GitHub ZIP](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)
2. Extract it.
3. Open the `termux-nova-main/windows` folder.
4. Double-click `install.cmd`, then open a new CMD session.

**Windows safety:** the CMD installer changes the current user's AutoRun registry value; preserve an existing setting before running it. Each Windows guide explains the check and backup.

[Back to README + the combined demo image](../README.md) · **by rugo**
