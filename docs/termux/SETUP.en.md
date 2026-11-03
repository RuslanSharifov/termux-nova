# Termux Nova — Android Termux setup

[← Main README and demo](../../README.md) · [Windows CMD instructions](../cmd/SETUP.en.md)

## 1. Install — one copy and paste

**Copy the entire block below once and paste it into Termux.** It downloads the repo, installs Nova and finishes by running `clear`.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

The installer may ask whether to disable other UI/prompt tools and whether to auto-restore your chosen theme on each startup. Read the prompts; for auto restore, **Enter = yes**. Nova then starts automatically in later interactive Termux sessions.

> If `~/termux-nova` already exists, the `git clone` step stops. Use the **Update** instructions below instead.

## 2. How to use Nova

Open Termux again or use these commands after installation. Start with `nova console` for the settings panel.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Themes and startup

Built-in themes: `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` restores the chosen palette on new sessions. Control the startup banner and the banner after `clear` via `nova console`.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

### Change the large NOVA lettering

Open `nova console` and choose **9) Change banner text**. Enter your message and press Enter. Uppercase/lowercase letters, numbers, all printable ASCII punctuation and many Unicode characters render as blocks; unsupported characters show as `?`. Maximum 64 characters; long text wraps. Press Enter on an empty input to restore NOVA.

```bash
nova banner set "RUSLAN 2026!"
nova banner
nova banner reset
```

## 4. Custom commands — add, list, edit, delete

`///` separates sequential steps. Each step runs only if the previous one succeeds. This example uses Git (installed during setup).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

After changing command definitions, reopen Termux or run `source ~/.bashrc`. Never save passwords or tokens inside custom commands.

## 5. Update an existing installation

If the repo is already cloned, don't clone it again. Paste this one update block. The installer may ask setup questions again.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Troubleshooting

1. **`nova: command not found`** — reopen Termux; if needed run `cd ~/termux-nova && bash install.sh`.
2. **Colors did not change** — run `pkg install -y termux-tools`, then `nova set dracula`.
3. **Theme resets** — check `nova current` and run `nova auto on`.
4. **Custom command won't work** — check `nova cmd` and run `source ~/.bashrc`.
5. **An old prompt changed** — review the `.nova-backup-*` files made during installation. `nova restore` replaces your whole `~/.bashrc` with the latest backup, possibly losing later edits.

## 7. Uninstall and safety

Use this block to disable startup restoration and remove Nova's shell hooks and installed command. It does not automatically restore your prior terminal colors.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**Optional permanent deletion of settings and custom commands:** after saving anything you need, run `rm -rf ~/.config/termux-nova ~/.cache/termux-nova`.

**Note:** This is the current Bash-based theme/command manager. SQLite usage counts, ghost-text autosuggestions and Tab acceptance are not yet implemented. Android's native menus and buttons are not altered.

---

Made by **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
