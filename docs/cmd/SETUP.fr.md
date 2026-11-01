# Termux Nova — installation sur Windows CMD

[← README et démo](../../README.md) · [Guide Android Termux](../termux/SETUP.fr.md)

## 1. Installation — télécharger le ZIP et ouvrir install.cmd

**Sous Windows, aucune commande d'installation n'est à copier.** Suivez ces 4 étapes :

1. **[Télécharger le ZIP termux-nova](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip)**.
2. Extraire l'archive ZIP.
3. Ouvrir `termux-nova-main`, puis le dossier `windows`.
4. **Double-cliquer sur `install.cmd`**, répondre aux questions et **ouvrir une nouvelle fenêtre CMD**.

**Important :** si vous avez déjà des scripts de démarrage CMD, sauvegardez AutoRun avant l'étape 4. Nova peut remplacer la valeur `HKCU\Software\Microsoft\Command Processor\AutoRun`. La procédure facultative figure ci-dessous.

L'installateur utilise PowerShell pour copier Nova dans le profil utilisateur et ajouter le dossier au PATH. Windows Terminal est conseillé pour les couleurs. Pour les macros `doskey`, choisissez un profil **Command Prompt (CMD)**, pas PowerShell.

## 2. Utiliser Nova

Dans une nouvelle fenêtre CMD, saisissez `nova console`. Naviguez avec les flèches et Entrée, ou un numéro suivi d'Entrée.

```cmd
nova console
nova list
nova current
nova doctor
```

## 3. Thèmes et démarrage automatique

Thèmes : `nova-dark`, `dracula`, `gruvbox`, `nord`. Les couleurs s'appliquent surtout dans Windows Terminal. `nova auto on` restaure le thème au démarrage. Les bannières au démarrage et après `cls` se règlent avec `nova console`.

```cmd
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Commandes personnelles — ajouter, lister, modifier, supprimer

`///` sépare les étapes exécutées successivement. L'exemple nécessite Git for Windows. Après modification des macros, **ouvrez une nouvelle fenêtre CMD**.

```cmd
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

## 5. Mise à jour

Téléchargez le nouveau [ZIP GitHub](https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip), extrayez-le, lancez le nouveau `termux-nova-main/windows/install.cmd` et rouvrez CMD. Une nouvelle installation peut aussi remplacer AutoRun.

## 6. Facultatif : sauvegarder CMD AutoRun

**Avant l'installation**, ces commandes CMD permettent de vérifier AutoRun et d'exporter la clé du registre. Une erreur d'export si la clé n'existe pas est normale. Vérifiez le fichier `.reg` avant toute restauration ultérieure.

```cmd
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
reg export "HKCU\Software\Microsoft\Command Processor" "%USERPROFILE%\cmd-autostart-before-nova.reg" /y
```

## 7. Dépannage

1. **`nova` n'est pas reconnu** — ouvrez une nouvelle fenêtre CMD, vérifiez `where nova`, puis relancez `install.cmd` si nécessaire.
2. **Le thème ne change pas** — utilisez le profil Command Prompt de Windows Terminal et lancez `nova doctor`. Les commentaires de `settings.json` peuvent empêcher sa lecture.
3. **La bannière manque** — lancez `nova hook` dans CMD et ouvrez une nouvelle fenêtre ; `cmd /d` désactive AutoRun.
4. **Une commande personnelle échoue** — vérifiez `nova cmd` et rouvrez CMD.

## 8. Désinstallation et confidentialité

Désactivez d'abord la restauration automatique et vérifiez AutoRun. **Supprimez la valeur AutoRun uniquement si elle appartient encore à Nova**, sinon d'autres scripts de démarrage pourraient être affectés. Sauvegardez les commandes de `%APPDATA%\termux-nova`, supprimez le dossier et retirez-le du PATH utilisateur dans Windows Environment Variables. Le cache `%LOCALAPPDATA%\termux-nova` peut aussi être supprimé.

```cmd
nova auto off
reg query "HKCU\Software\Microsoft\Command Processor" /v AutoRun
```

Pour restaurer les couleurs Windows Terminal, vérifiez `settings.json.nova-backup` ; des changements répétés de thème peuvent l'avoir écrasé. Ne placez ni mots de passe ni jetons dans les commandes personnelles.

**Portée :** cette version s'intègre à Windows CMD/Windows Terminal et ne modifie pas l'interface native Android.

---

Créé par **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
