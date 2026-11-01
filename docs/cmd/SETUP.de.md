# Termux Nova — Windows-CMD-Installation

[← README und Demo](../../README.md) · [Android-Termux-Anleitung](../termux/SETUP.de.md)

## 1. Installation — ZIP laden und install.cmd doppelklicken

**Unter Windows müssen keine Installationsbefehle kopiert werden.** Einfach diese 4 Schritte:

1. **[termux-nova ZIP herunterladen](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. ZIP-Archiv entpacken.
3. Den Ordner `termux-nova-main`, dann den Unterordner `windows` öffnen.
4. **`install.cmd` doppelklicken**, die Installationsfragen beantworten und anschließend **ein neues CMD-Fenster öffnen**.

**Wichtig:** Wer eigene CMD-Autostartskripte verwendet, sollte AutoRun vor Schritt 4 sichern. Nova kann den Wert `HKCU\Software\Microsoft\Command Processor\AutoRun` überschreiben. Die optionale Sicherung steht weiter unten.

Der Installer kopiert Nova über PowerShell ins Benutzerprofil und ergänzt PATH. Für Farben wird Windows Terminal empfohlen. `doskey`-Makros funktionieren im Profil **Command Prompt (CMD)**, nicht in PowerShell.

## 2. Nova verwenden

In einem neuen CMD-Fenster `nova console` eingeben. Im Menü Pfeiltasten + Enter oder Nummer + Enter verwenden.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Designs und automatischer Start

Designs: `nova-dark`, `dracula`, `gruvbox`, `nord`. Farben wirken hauptsächlich in Windows Terminal. `nova auto on` stellt das gewählte Design beim Start wieder her. Banner beim Start und nach `cls` lassen sich über `nova console` einstellen.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Eigene Befehle — hinzufügen, anzeigen, ändern, löschen

`///` trennt nacheinander auszuführende Schritte. Für das Beispiel muss Git for Windows installiert sein. Nach Änderungen ein **neues CMD-Fenster** öffnen, damit die Makros neu geladen werden.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Aktualisierung

Die aktuelle [GitHub-ZIP-Datei](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip) herunterladen, entpacken, die neue `termux-nova-main/windows/install.cmd` starten und CMD neu öffnen. Bei Neuinstallation kann AutoRun erneut überschrieben werden.

## 6. Optional: CMD AutoRun sichern

**Vor der Installation** in CMD mit diesen Befehlen AutoRun prüfen und den Registry-Schlüssel exportieren. Wenn der Schlüssel fehlt, ist der Exportfehler normal. Eine `.reg`-Datei vor späterer Wiederherstellung prüfen.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Fehlerbehebung

1. **`nova` wird nicht erkannt** — CMD neu öffnen, `where nova` prüfen und eventuell `install.cmd` erneut starten.
2. **Design ändert sich nicht** — Command-Prompt-Profil in Windows Terminal verwenden und `nova doctor` ausführen. Kommentare in `settings.json` können das Parsen verhindern.
3. **Banner fehlt** — `nova hook` in CMD ausführen und ein neues Fenster öffnen; `cmd /d` deaktiviert AutoRun.
4. **Eigener Befehl funktioniert nicht** — `nova cmd` prüfen und CMD neu öffnen.

## 8. Deinstallation und Datenschutz {#uninstall}

Erst automatische Wiederherstellung abschalten und AutoRun prüfen. **Den AutoRun-Wert nur löschen, wenn er noch zu Nova gehört**; andernfalls könnten andere Startskripte beschädigt werden. Eigene Befehle unter `%APPDATA%\termux-nova` sichern, dann den Ordner löschen und über Windows Environment Variables aus dem Benutzer-PATH entfernen. Der Cache `%LOCALAPPDATA%\termux-nova` kann ebenfalls gelöscht werden.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

Für frühere Windows-Terminal-Farben `settings.json.nova-backup` prüfen; wiederholte Designwechsel können das Backup überschrieben haben. Keine Passwörter oder Tokens in eigenen Befehlen speichern.

**Umfang:** Diese Version integriert sich in Windows CMD/Windows Terminal, verändert aber keine nativen Android-Menüs.

---

Erstellt von **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
