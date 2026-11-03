# Android Termux — choose your language

**Customize the large banner:** `nova console` → **Change banner text**, or `nova banner set "HELLO 2026!"`. Reset with `nova banner reset`.


**One paste installs Nova and clears the screen when finished:**

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

| Language | Full setup and usage |
|---|---|
| 🇦🇿 Azərbaycan | [SETUP.az.md](SETUP.az.md) |
| 🇬🇧 English | [SETUP.en.md](SETUP.en.md) |
| 🇹🇷 Türkçe | [SETUP.tr.md](SETUP.tr.md) |
| 🇷🇺 Русский | [SETUP.ru.md](SETUP.ru.md) |
| 🇩🇪 Deutsch | [SETUP.de.md](SETUP.de.md) |
| 🇫🇷 Français | [SETUP.fr.md](SETUP.fr.md) |

After install: `nova console`. [Windows CMD instructions](../cmd/README.md) · [README](../../README.md)

**rugo / Ruslan Sharifov**
