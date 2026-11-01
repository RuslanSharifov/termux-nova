# Termux Nova — Einrichtung unter Android Termux

[← README und Demo](../../README.md) · [Windows-CMD-Anleitung](../cmd/SETUP.de.md)

## 1. Installation — einmal kopieren und einfügen

**Den gesamten Block unten einmal kopieren und in Termux einfügen.** Er lädt das Repository, installiert Nova und führt zuletzt `clear` aus.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

Während der Installation werden möglicherweise andere UI-/Prompt-Tools und die automatische Designwiederherstellung abgefragt. Fragen zuerst lesen; für automatische Wiederherstellung **Enter = ja**. In künftigen interaktiven Termux-Sitzungen startet Nova automatisch.

> Wenn `~/termux-nova` bereits vorhanden ist, stoppt `git clone`. Dann den Abschnitt **Aktualisierung** unten verwenden.

## 2. Nova verwenden

Termux nach der Installation neu öffnen oder die folgenden Befehle ausführen. Das Einstellungsmenü startet mit `nova console`.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Designs und Startverhalten

Enthaltene Designs: `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` stellt das gespeicherte Design bei neuen Sitzungen wieder her. Banner beim Start und nach `clear` sind in `nova console` konfigurierbar.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Eigene Befehle — hinzufügen, anzeigen, ändern, löschen

`///` trennt aufeinanderfolgende Schritte. Der nächste startet nur nach erfolgreichem vorherigem Schritt. Das Beispiel verwendet Git (wird installiert).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

Nach Änderungen an eigenen Befehlen Termux neu öffnen oder `source ~/.bashrc` ausführen. Keine Passwörter oder Tokens als Befehl speichern.

## 5. Bestehende Installation aktualisieren

Bei vorhandenem Klon nicht erneut klonen. Stattdessen diesen einen Update-Block einfügen. Installationsfragen können erneut erscheinen.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Fehlerbehebung

1. **`nova: command not found`** — Termux neu öffnen; gegebenenfalls `cd ~/termux-nova && bash install.sh`.
2. **Farben ändern sich nicht** — `pkg install -y termux-tools` und danach `nova set dracula` ausführen.
3. **Design wird zurückgesetzt** — `nova current` prüfen und `nova auto on` aktivieren.
4. **Eigener Befehl funktioniert nicht** — mit `nova cmd` prüfen und `source ~/.bashrc` ausführen.
5. **Vorheriger Prompt wurde verändert** — `.nova-backup-*`-Dateien prüfen. `nova restore` ersetzt die gesamte `~/.bashrc` durch das letzte Backup und kann neuere Änderungen löschen.

## 7. Deinstallation und Sicherheit {#uninstall}

Dieser Block deaktiviert die automatische Wiederherstellung und entfernt Nova-Startzeilen sowie das Kommando. Frühere Terminalfarben werden nicht automatisch wiederhergestellt.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**Optionale endgültige Datenlöschung:** benötigte Daten zuerst sichern, dann `rm -rf ~/.config/termux-nova ~/.cache/termux-nova` ausführen.

**Hinweis:** Die aktuelle Bash-Version verwaltet Designs und eigene Befehle. SQLite-Nutzungsstatistik, Ghost-Text-Vorschläge und Tab-Übernahme sind noch nicht umgesetzt. Android-Menüs und Schaltflächen bleiben unverändert.

---

Erstellt von **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
