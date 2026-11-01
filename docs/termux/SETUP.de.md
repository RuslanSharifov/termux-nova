# Ausführliche Termux-Installationsanleitung

> **Termux Nova v2.x** · **DE** · [Windows CMD](../cmd/SETUP.de.md) · [Documentation index](../README.md)

Diese Anleitung erklärt Installation, Einrichtung, Updates, Fehlerbehebung und Entfernung von termux-nova unter **Android Termux**. Für Windows gibt es die [CMD-Anleitung](../cmd/SETUP.de.md).

## Requirements / 01

Android-Gerät, aktuelle Termux-Version aus F-Droid oder dem offiziellen GitHub, Internetverbindung für die Erstinstallation und genügend Speicherplatz. Root ist nicht erforderlich. Diese Befehle gehören **in Termux**, nicht in Windows CMD.

## 02 — Prepare Termux

**1. Termux vorbereiten.** App öffnen, Paketlisten aktualisieren und Git installieren. `pkg` ist die Termux-Paketverwaltung, `git` lädt das Repository herunter.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Repository klonen.** `cd ~` wechselt ins Home-Verzeichnis, `git clone` lädt das Projekt herunter und das letzte `cd` öffnet den Projektordner.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Alternative: ZIP ohne Git.** Diese Befehle laden das Archiv des `main`-Branches. Nur eine Methode auswählen: Git oder ZIP. ZIP-Installationen werden durch erneutes Herunterladen aktualisiert.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Installer ausführen.** Mit `ls` prüfen, ob `install.sh`, `nova.sh` und `themes/` vorhanden sind, danach den Bash-Installer starten.

```bash
ls install.sh nova.sh themes
bash install.sh
```

Der Installer installiert `termux-tools` und `curl`, kopiert `nova` und die Designs nach Termux und ergänzt Start-Hooks in `~/.bashrc`. Er fragt, ob andere Prompt-/UI-Tools deaktiviert werden sollen, und legt bei Zustimmung datierte Backups der rc-Dateien an. Bei der Frage nach automatischer Wiederherstellung bedeutet **Enter = ja**, `n` = nein. Standarddesign ist `nova-dark`. Eine neue Termux-Sitzung öffnen oder im aktuellen Bash `source ~/.bashrc` ausführen.

```bash
source ~/.bashrc
```

**Achtung:** Die Frage zum Deaktivieren anderer UI-Tools bewusst beantworten. Passende rc-Zeilen werden auskommentiert. Wichtige Shell-Konfiguration vorher separat sichern.

## 05 — Verify and configure

**4. Installation prüfen und Menü öffnen.** `nova doctor` zeigt die Diagnose; `nova console` öffnet das nummerierte Einstellungsmenü. `nova list` zeigt Designs, `nova current` den gespeicherten Zustand.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Designs und Startverhalten.** `nova set dracula` ändert die Farben; `nova auto on` stellt das gespeicherte Design bei künftigen Starts wieder her. Das große Banner kann beim Start und nach `clear` erscheinen; beides ist in `nova console` einstellbar. Android-Schaltflächen werden nicht verändert.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Eigene Befehle anlegen (CRUD).** Ein Auslöser kann mit dem Namen eines installierten Programms beginnen. `///` trennt aufeinanderfolgende Schritte; der nächste startet nur nach Erfolg des vorherigen. Für das Beispiel wird Git benötigt.

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

**7. Aktualisieren.** Im geklonten Repository `git pull --ff-only` und anschließend `bash install.sh` ausführen. Lokale Änderungen können Updates blockieren; vorher sichern. Der Installer fragt eventuell Einstellungen erneut ab.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Fehlerbehebung.**

1. `nova: command not found` — `bash install.sh` erneut ausführen, `command -v nova` prüfen und neue Sitzung öffnen.
2. Farben bleiben gleich — `pkg install -y termux-tools` und `nova set dracula` ausführen; App erneut öffnen.
3. Design wird zurückgesetzt — `nova current` prüfen und `nova auto on` aktivieren.
4. Eigener Befehl funktioniert nicht — mit `nova cmd` prüfen, danach `source ~/.bashrc` ausführen.
5. Alter Prompt verschwunden — Backups `~/.bashrc.nova-backup-*` prüfen; `nova restore` ersetzt die gesamte `.bashrc` durch das neueste Backup und kann spätere Änderungen überschreiben.

## 10 — Uninstall and privacy

**9. Deinstallation und Daten.** Automatische Wiederherstellung deaktivieren, die Nova-Hooks aus `.bashrc` und die CLI entfernen. Die letzte Zeile löscht Einstellungen, eigene Befehle und Cache **dauerhaft**; weglassen, wenn Daten erhalten bleiben sollen.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Eigene Befehle liegen in `~/.config/termux-nova/commands`. Keine Passwörter oder Tokens eintragen: die Daten werden lokal gespeichert und ausgeführt. Diese Version enthält noch keine SQLite-Nutzungsstatistik oder Ghost-Text-Vervollständigung.

---

**Autor:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Alle Sprachen und Plattformen](../README.md).
