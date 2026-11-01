# Complete Termux installation guide

> **Termux Nova v2.x** · **EN** · [Windows CMD](../cmd/SETUP.en.md) · [Documentation index](../README.md)

This guide covers installation, setup, updates, troubleshooting, and removal of termux-nova on **Android Termux**. For a Windows computer, use the [CMD guide](../cmd/SETUP.en.md).

## Requirements / 01

An Android phone with a current Termux release from F-Droid or the official GitHub distribution, an internet connection for first installation, and available storage. No root access is needed. Run these commands **inside Termux**, not Windows CMD.

## 02 — Prepare Termux

**1. Prepare Termux.** Open the app, update package indexes, and install Git. `pkg` is Termux's package manager; `git` downloads the repository.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Clone the repository.** `cd ~` goes to your home directory, `git clone` downloads the project, and the final `cd` enters its directory.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Alternative: download a ZIP without Git.** These commands download the main-branch archive. Choose either Git or ZIP, not both. Updating a ZIP install requires downloading the new archive again.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Run the installer.** Use `ls` to verify `install.sh`, `nova.sh`, and `themes/` are present, then execute the Bash installer.

```bash
ls install.sh nova.sh themes
bash install.sh
```

The installer installs `termux-tools` and `curl`, copies the `nova` command and themes into Termux, and configures `~/.bashrc` startup hooks. It asks permission to disable competing prompt/UI tools and makes timestamped rc-file backups if you agree. For auto-restoring the theme, **Enter = yes**, `n` = no. The default theme is `nova-dark`. Open a new Termux session or run `source ~/.bashrc` to activate hooks in the current Bash session.

```bash
source ~/.bashrc
```

**Warning:** read the prompt before allowing another UI tool to be disabled. The installer comments matching rc-file lines. Keep a separate copy of important custom shell settings.

## 05 — Verify and configure

**4. Verify the installation and open the menu.** `nova doctor` reports diagnostic information; `nova console` opens the numbered settings panel. `nova list` shows themes and `nova current` prints saved settings.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Themes and startup.** `nova set dracula` changes colors and saves the selection; `nova auto on` reapplies the saved theme on later starts. The large banner can appear on startup and after `clear`; toggle these separately in `nova console`. Nova changes terminal colors and shell behavior, **not the Android application's native buttons**.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Create your own commands (CRUD).** A trigger can begin with an existing executable name. Separate sequential steps with `///`; the next step runs only when the previous succeeds. The Git example requires Git.

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
source ~/.bashrc
```

Optional Node.js example (requires `pkg install nodejs` and an npm project):

```bash
pkg install -y nodejs
nova cmd add "npm run full" "npm install /// npm run dev"
source ~/.bashrc
npm run full
```

`nova cache clear` rebuilds generated command wrappers if required.

## 08 — Update an existing Git installation

**7. Update.** In a Git clone, use `git pull --ff-only`, then rerun `bash install.sh`. Git may refuse to update files with local changes; save those changes first. The installer might ask its setup questions again.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Troubleshooting.**

1. `nova: command not found` — rerun `bash install.sh`, check `command -v nova`, and open a new Termux session.
2. Colors remain unchanged — run `pkg install -y termux-tools` and `nova set dracula`; reopen the app.
3. Theme resets at startup — inspect `nova current` and enable `nova auto on`.
4. Custom command does not work — check `nova cmd` and run `source ~/.bashrc` or open a new session.
5. Previous prompt disappeared — inspect the timestamped `~/.bashrc.nova-backup-*` backups; `nova restore` replaces the entire current `.bashrc` with the latest backup, potentially overwriting later changes.

## 10 — Uninstall and privacy

**9. Removal and data.** Disable automatic restoration, remove Nova's marked hooks, and remove the installed CLI. The last line below **permanently deletes** settings, custom commands, and cache; skip it if you want to keep that data.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Your custom commands are stored in `~/.config/termux-nova/commands`. Do not include passwords or tokens in command definitions: entries are stored locally and are executable. This release does not claim SQLite usage statistics or ghost-text autocomplete, as those are not implemented in the current code.

---

**Author:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [All languages and platforms](../README.md).
