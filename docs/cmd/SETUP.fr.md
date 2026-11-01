# Guide complet d'installation sous Windows CMD

> **Termux Nova v2.x** · **FR** · [Termux Android](../termux/SETUP.fr.md) · [Documentation index](../README.md)

Ce guide concerne la **version Windows** exécutée dans `cmd.exe` ou le profil Command Prompt de Windows Terminal. Pour Android, consultez le [guide Termux](../termux/SETUP.fr.md). Sous Windows on lance `windows/install.cmd` ; `pkg` n'est pas une commande Windows.

## Requirements / 01

Windows 10/11, Windows PowerShell 5.1 inclus, Git ou archive ZIP, Windows Terminal conseillé pour les couleurs. Les droits administrateur ne sont généralement pas nécessaires. Sans `winget`, installez Git for Windows manuellement ou utilisez le ZIP.

## 02 — Prepare Command Prompt

**1. Préparer CMD.** Ouvrez l'Invite de commandes depuis Démarrer ou Windows Terminal → Command Prompt. Installez Git via `winget` si disponible, sinon utilisez le ZIP. Après installation de Git, ouvrez une **nouvelle fenêtre CMD**.

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

**2. Cloner le dépôt sur le PC.** Ces commandes placent le projet dans Downloads. `cd /d` change de lecteur et de dossier. `dir` doit afficher `install.cmd`, `install.ps1`, `nova.ps1`.

```cmd
cd /d "%USERPROFILE%\Downloads"
git clone https://github.com/RuslanSharifov/termux-nova.git
cd /d "%USERPROFILE%\Downloads\termux-nova\windows"
dir
```

**Alternative : ZIP sans Git.** Ouvrez le lien dans le navigateur, extrayez l'archive dans Downloads et entrez dans le dossier `windows` du projet. Adaptez le chemin à votre lieu d'extraction.

[Download main.zip](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova-main\windows"
dir
```

## 04 — Back up CMD AutoRun

**3. Vérifier et sauvegarder CMD AutoRun avant installation.** Pour la bannière et les macros `doskey`, Nova modifie la valeur utilisateur `HKCU\Software\Microsoft\Command Processor\AutoRun`. **Une valeur AutoRun existante peut être écrasée.** Vérifiez avec `reg query` et exportez la clé avec `reg export` si elle existe. Une erreur d'export si la clé n'existe pas est normale.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 05 — Install Windows version

**4. Lancer l'installateur Windows.** Dans le dossier `windows`, exécutez `install.cmd`. Il lance PowerShell 5.1 avec `-ExecutionPolicy Bypass` pour ce processus uniquement, sans modifier définitivement la politique globale.

```cmd
install.cmd
```

Equivalent manual command (from the `windows` folder):

```cmd
powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1
```

L'installateur copie `nova.ps1`, `nova.cmd`, `themes.json` dans `%APPDATA%\termux-nova`, ajoute ce dossier au `PATH` utilisateur, installe les hooks CMD AutoRun, demande si la restauration automatique est souhaitée (**Entrée = oui**) et essaie d'appliquer `nova-dark` dans Windows Terminal. **Ouvrez une nouvelle fenêtre CMD** après installation pour prendre en compte PATH et AutoRun.

## 06 — Verify and open console

**5. Vérifier et ouvrir le panneau.** `where nova` affiche le chemin de la commande. `nova console` se pilote avec Haut/Bas et Entrée ou chiffre + Entrée. `nova doctor` affiche les diagnostics.

```cmd
where nova
nova doctor
nova console
nova list
nova current
```

## 07 — Apply themes and control startup

**6. Thèmes et fonctionnement CMD.** `nova set dracula` change le schéma dans `settings.json` de Windows Terminal ; la console classique n'affiche pas forcément le résultat. Choisissez le profil **Command Prompt** dans Windows Terminal : les macros CMD ne fonctionnent pas dans un profil PowerShell. Réglez la bannière au démarrage et après `cls` dans `nova console`.

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

**7. Ajouter, modifier et supprimer ses commandes.** `///` sépare les étapes exécutées dans l'ordre. L'exemple Git nécessite Git ; l'exemple npm facultatif nécessite Node.js/npm installé séparément. Ouvrez une nouvelle fenêtre CMD après modification des macros.

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

**8. Mettre à jour.** Pour un clonage Git, utilisez `git pull --ff-only`, puis relancez `install.cmd`. Pour le ZIP, téléchargez à nouveau l'archive et réinstallez depuis le nouveau dossier `windows`.

```cmd
cd /d "%USERPROFILE%\Downloads\termux-nova"
git status
git pull --ff-only
cd windows
install.cmd
```

## 10 — Troubleshooting

1. `'nova' is not recognized` — ouvrez une nouvelle fenêtre CMD, testez `where nova`, puis relancez `install.cmd` si nécessaire.
2. Les couleurs ne changent pas — utilisez Windows Terminal et `nova doctor`. Des commentaires dans `settings.json` peuvent empêcher sa lecture.
3. Pas de bannière — choisissez CMD, exécutez `nova hook`, puis ouvrez une nouvelle fenêtre. `cmd /d` ignore volontairement AutoRun.
4. La macro `cls` ne fonctionne pas — relancez `nova hook` puis CMD ; les macros `doskey` ne s'appliquent pas aux profils PowerShell.
5. L'ancien AutoRun a disparu — examinez le fichier `.reg` de sauvegarde et sauvegardez l'état actuel avant restauration.

## 11 — Uninstall and privacy

**9. Désinstaller.** Cette version ne possède pas de désinstallateur Windows distinct. Lancez d'abord `nova auto off`. Vérifiez via `reg query` qu'AutoRun appartient toujours à Nova avant de le supprimer ou de restaurer votre sauvegarde. `%APPDATA%\termux-nova` contient vos commandes : sauvegardez-le avant suppression. Supprimez le dossier du `PATH` utilisateur dans les *Environment Variables* de Windows. Pour restaurer les couleurs, examinez `settings.json.nova-backup` ; plusieurs changements de thème peuvent avoir écrasé cette sauvegarde.

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

Les commandes personnelles sont conservées dans `%APPDATA%\termux-nova\commands`. N'y placez pas de jetons secrets. Vérifiez les modifications du registre et de Windows Terminal avant installation.

---

**Auteur :** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Toutes les langues et plateformes](../README.md).
