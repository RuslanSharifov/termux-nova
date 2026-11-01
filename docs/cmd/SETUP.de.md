# Ausführliche Windows-CMD-Installationsanleitung

> **Termux Nova v2.x** · **DE** · [Termux Android](../termux/SETUP.de.md) · [Documentation index](../README.md)

Diese Anleitung betrifft die **Windows-Version** in `cmd.exe` oder im Command-Prompt-Profil von Windows Terminal. Für Android siehe [Termux-Anleitung](../termux/SETUP.de.md). Windows verwendet `windows/install.cmd`; `pkg` ist kein Windows-Befehl.

## Requirements / 01

Windows 10/11, integriertes Windows PowerShell 5.1, Git oder ZIP-Download sowie idealerweise Windows Terminal für Farbdesigns. Administratorrechte sind normalerweise nicht nötig. Ohne `winget` Git for Windows manuell installieren oder ZIP verwenden.

## 02 — Prepare Command Prompt

**1. CMD vorbereiten.** Eingabeaufforderung über Start oder Windows Terminal → Command Prompt öffnen. Git bei verfügbarem `winget` installieren, sonst ZIP-Methode verwenden. Nach Git-Installation ein **neues CMD-Fenster** öffnen.

```cmd
winget install --id Git.Git -e
```

Check Git in a **new** CMD window:

```cmd
git --version
where git
```

Optional Windows Terminal install (if `winget` is present):

```cmd
winget install --id Microsoft.WindowsTerminal -e
```

## 03 — Download or clone from GitHub

**2. Repository auf den PC klonen.** Diese Befehle laden das Projekt nach Downloads. `cd /d` wechselt Laufwerk und Ordner. `dir` sollte `install.cmd`, `install.ps1`, `nova.ps1` anzeigen.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Alternative: ZIP ohne Git.** Link im Browser öffnen, Archiv nach Downloads entpacken und zum Projekt-Unterordner `windows` wechseln. Den Pfad an den tatsächlichen Entpackort anpassen.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. CMD AutoRun vorab prüfen und sichern.** Nova schreibt für Banner und `doskey`-Makros den Benutzereintrag `HKCU\Software\Microsoft\Command Processor\AutoRun`. **Ein vorhandener AutoRun-Eintrag kann überschrieben werden.** Mit `reg query` prüfen und den vorhandenen Schlüssel über `reg export` sichern. Ein Exportfehler bei nicht vorhandenem Schlüssel ist normal.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Windows-Installer starten.** Im Ordner `windows` `install.cmd` ausführen. Das startet PowerShell 5.1 mit `-ExecutionPolicy Bypass` nur für diesen Prozess; die globale Richtlinie bleibt unverändert.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

Der Installer kopiert `nova.ps1`, `nova.cmd` und `themes.json` nach `%APPDATA%\termux-nova`, ergänzt den Benutzer-`PATH`, setzt CMD AutoRun-Hooks, fragt nach automatischer Wiederherstellung (**Enter = ja**) und versucht, `nova-dark` in Windows Terminal anzuwenden. Danach **ein neues CMD-Fenster öffnen**, damit PATH und AutoRun geladen werden.

## 06 — Verify and open console

**5. Installation prüfen und Menü öffnen.** `where nova` zeigt den Pfad zum Launcher. `nova console` unterstützt Pfeil hoch/runter und Enter oder Zahl + Enter. `nova doctor` zeigt Diagnosedaten.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Designs und CMD-Verhalten.** `nova set dracula` passt das Farbschema in Windows Terminal `settings.json` an; die klassische Konsole zeigt es eventuell nicht. In Windows Terminal ein **Command-Prompt-Profil** wählen: CMD-Makros funktionieren nicht im PowerShell-Profil. Startbanner und Banner nach `cls` lassen sich in `nova console` umschalten.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
nova hook
```

## 08 — Custom commands: create / read / edit / delete

**7. Eigene Befehle hinzufügen, ändern, löschen.** `///` trennt sequenzielle Schritte. Das Git-Beispiel benötigt Git; das optionale npm-Beispiel erfordert eine separate Node.js/npm-Installation. Nach Makroänderungen ein neues CMD-Fenster öffnen.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
nova cache clear
```

Optional example for projects with Node.js/npm already installed:

```cmd
nova cmd add "npm run full" "npm install /// npm run dev"
nova cmd
```

## 09 — Update an existing Git clone

**8. Aktualisieren.** Bei Git-Klon `git pull --ff-only` und danach `install.cmd` starten. Bei ZIP-Installation das Archiv neu laden und aus dem neuen `windows`-Ordner installieren.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — neues CMD öffnen, `where nova` prüfen und bei Bedarf `install.cmd` erneut starten.
2. Farben ändern sich nicht — Windows Terminal verwenden und `nova doctor` ausführen. Kommentare in `settings.json` können das Einlesen verhindern.
3. Kein Banner — CMD-Profil verwenden, `nova hook` starten und neues Fenster öffnen. `cmd /d` überspringt AutoRun.
4. `cls`-Makro funktioniert nicht — `nova hook` erneut ausführen und CMD neu öffnen; `doskey`-Makros gelten nicht in PowerShell.
5. Altes AutoRun verschwunden — gespeichertes `.reg`-Backup prüfen; vor Wiederherstellung aktuellen Registry-Stand sichern.

## 11 — Uninstall and privacy

**9. Entfernen.** Ein eigener Windows-Uninstaller ist derzeit nicht enthalten. Zuerst `nova auto off`. Über `reg query` sicherstellen, dass AutoRun noch von Nova stammt, danach löschen oder das ursprüngliche Registry-Backup wiederherstellen. `%APPDATA%\termux-nova` enthält eigene Befehle: vorher sichern. Den Ordner in Windows *Environment Variables* aus dem Benutzer-`PATH` entfernen. Für frühere Terminalfarben `settings.json.nova-backup` prüfen; häufige Designwechsel können dieses Backup überschrieben haben.

Run the first command in CMD. **Only delete AutoRun if it contains Nova's hook and you have a backup of any previous value.**

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg delete "HKCU\Software\Microsoft\Command Processor" /v AutoRun /f
```

**Optional, irreversible removal of the installed tool and user data** (after exporting any custom commands you need):

```cmd
rmdir /s /q "%APPDATA%\termux-nova"
rmdir /s /q "%LOCALAPPDATA%\termux-nova"
```

Eigene Befehle liegen unter `%APPDATA%\termux-nova\commands`. Keine Geheimnisse oder Tokens dort speichern. Änderungen an Registry und Windows-Terminal-Einstellungen vorab prüfen.

---

**Autor:** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Alle Sprachen und Plattformen](../README.md).
