# termux-nova Setup Guide (English)

by **rugo**

## 1. Requirements

- Android with Termux (from F-Droid or the GitHub release; the old Play Store build is outdated)
- Internet for the first install

## 2. Get the files

```bash
pkg install -y git
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
```

Or with the zip: `pkg install -y unzip && unzip termux-nova.zip && cd termux-nova`

## 3. Run the installer

```bash
bash install.sh
```

The installer:

1. Installs `termux-tools` (for `termux-reload-settings`)
2. Copies the `nova` command and themes into Termux
3. Asks whether to disable other prompt/UI tools (Starship, Oh My Posh, etc.). A backup of your rc files is made first.
4. Installs the `~/.bashrc` hooks
5. Asks whether to enable auto restore (Enter = yes)
6. Applies the default `nova-dark` theme

## 4. Open the settings panel

```bash
nova console
```

From here you can change the theme, toggle auto restore and the banners, manage custom commands, clear the cache, reset settings and restore `~/.bashrc`.

## 5. Use it

```bash
nova list
nova set dracula
nova current
```

## 6. Custom commands

```bash
nova cmd add "npm run full" "npm i && npm run dev"
nova cmd
nova cmd edit "npm run full" "npm i && npm run build"
nova cmd rm "npm run full"
```

After a change, open a new session or run `source ~/.bashrc`. Then `npm run full` works in any folder.

## 7. Startup behaviour

Each new Termux session runs `clear` and then shows the NOVA banner. Typing `clear` also shows the banner again. Both can be switched off in `nova console`.

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| `nova: command not found` | Run `bash install.sh` again or restart Termux |
| Colors did not change | Run `nova set <theme>` again |
| `termux-reload-settings: not found` | `pkg install termux-tools` |
| Theme resets on start | Run `nova current`. If auto restore is off, run `nova auto on` |
| Custom command does not run | Open a new session or run `source ~/.bashrc` |
| Old prompt is still visible | Check `~/.bashrc` for lines starting with `# disabled by termux-nova`; to undo, run `nova restore` |

## 9. Uninstall

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
rm -f "$PREFIX/bin/nova"
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

---

Made by **rugo** · MIT License
