```
 ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗
 ████╗  ██║██╔═══██╗██║   ██║██╔══██╗
 ██╔██╗ ██║██║   ██║██║   ██║███████║
 ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║
 ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║
 ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝
```

# termux-nova

**Termux & Windows UI Theme Switcher and Command Manager** · by **rugo** · MIT License

termux-nova changes the look of your Termux with one command, remembers your choice, and lets you create your own shortcut commands. For example, `npm run full` can run `npm i` followed by `npm run dev` from anywhere.

## Features

- Theme switching with an animated loader (`nova set dracula`)
- Auto restore: your theme is re-applied on every Termux start (enable once)
- Banner on session start and after `clear`
- Settings panel (`nova console`) with a numbered menu
- Custom commands with full CRUD (add, read, edit, delete), including chained steps
- Cache clearing and settings reset from the panel
- Restore of `~/.bashrc` from the backup made during install
- Works without root

## Windows (cmd / Windows Terminal)

The same features are available on Windows as a PowerShell tool in the `windows/` folder. Double-click `windows/install.cmd`, then open a new Windows Terminal window and type `nova console`. Navigation works with the arrow keys and Enter, or by typing a number.

| Language | Windows guide |
|---|---|
| English | [docs/SETUP-WINDOWS.en.md](docs/SETUP-WINDOWS.en.md) |
| Türkçe | [docs/SETUP-WINDOWS.tr.md](docs/SETUP-WINDOWS.tr.md) |
| Azərbaycanca | [docs/SETUP-WINDOWS.az.md](docs/SETUP-WINDOWS.az.md) |

## Quick install

```bash
pkg install -y git
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
bash install.sh
```

Or with the zip file:

```bash
unzip termux-nova.zip
cd termux-nova
bash install.sh
```

Setup guides with troubleshooting and uninstall steps:

| Language | Guide |
|---|---|
| English | [docs/SETUP.en.md](docs/SETUP.en.md) |
| Türkçe | [docs/SETUP.tr.md](docs/SETUP.tr.md) |
| Azərbaycanca | [docs/SETUP.az.md](docs/SETUP.az.md) |

## Commands

| Command | What it does |
|---|---|
| `nova console` | Open the settings panel (menu) |
| `nova list` | Show all themes (● = active) |
| `nova set <theme>` | Apply a theme and remember it |
| `nova current` | Show all current settings |
| `nova auto on\|off` | Auto restore the theme on every start |
| `nova banner` | Show the banner now |
| `nova cmd` | List custom commands |
| `nova cmd add "<trigger>" "<cmd>"` | Create a custom command |
| `nova cmd edit "<trigger>" "<cmd>"` | Change a custom command |
| `nova cmd rm "<trigger>"` | Delete a custom command |
| `nova cache clear` | Clear cache and rebuild command wrappers |
| `nova hook` | Reinstall the `~/.bashrc` hooks |
| `nova restore` | Restore `~/.bashrc` from the install backup |
| `nova help` | Show help |

## Custom commands

```bash
nova cmd add "npm run full" "npm i && npm run dev"
```

Now typing `npm run full` in any folder runs `npm i`, and then `npm run dev` only if the first step succeeded. Other `npm` commands such as `npm install` are passed through unchanged. After adding or editing, open a new session or run `source ~/.bashrc`.

The trigger's first word must be an existing command name. Shell built-ins such as `cd`, `ls` and `clear` are not allowed.

## Adding your own theme

Create `~/.config/termux-nova/themes/mytheme.properties` with `background`, `foreground`, `cursor` and `color0` to `color15`, then run `nova set mytheme`.

## Project structure

```
termux-nova/
├── nova.sh        Termux tool (themes, panel, commands, hooks)
├── install.sh     Termux installer
├── windows/       Windows tool (PowerShell), installer and launchers
├── themes/        built-in color themes
├── docs/          setup guides for Termux and Windows (EN / TR / AZ)
├── LICENSE.md
└── README.md
```

## License

MIT. See [LICENSE.md](LICENSE.md).

---

Made with care by **rugo**
"# termux-nova" 
