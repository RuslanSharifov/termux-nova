# Guide complet d’installation sur Termux

> **Termux Nova v2.x** · **FR** · [Windows CMD](../cmd/SETUP.fr.md) · [Documentation index](../README.md)

Ce guide décrit l'installation, la configuration, les mises à jour, le dépannage et la suppression de termux-nova sur **Termux Android**. Sous Windows, consultez le [guide CMD](../cmd/SETUP.fr.md).

## Requirements / 01

Téléphone Android, version récente de Termux provenant de F-Droid ou du GitHub officiel, connexion Internet pour la première installation et espace disponible. Aucun accès root requis. Exécutez ces commandes **dans Termux**, pas dans Windows CMD.

## 02 — Prepare Termux

**1. Préparer Termux.** Ouvrez l'application, actualisez les paquets et installez Git. `pkg` est le gestionnaire de paquets de Termux ; `git` télécharge le dépôt.


```bash
pkg update && pkg upgrade -y
pkg install -y git
```


## 03 — Download the project (Git)

**2. Cloner le dépôt.** `cd ~` rejoint le dossier personnel, `git clone` télécharge le projet et le dernier `cd` ouvre son dossier.

```bash
cd ~
git clone https://github.com/RuslanSharifov/termux-nova.git
cd termux-nova
ls
```

**Alternative : archive ZIP sans Git.** Ces commandes téléchargent l'archive de la branche `main`. Choisissez Git ou ZIP, pas les deux. Pour mettre à jour une installation ZIP, téléchargez de nouveau l'archive.

```bash
pkg install -y curl unzip
cd ~
curl -fL https://github.com/RuslanSharifov/termux-nova/archive/refs/heads/main.zip -o termux-nova.zip
unzip termux-nova.zip
cd termux-nova-main
ls
```

## 04 — Install and activate

**3. Lancer l'installation.** Vérifiez avec `ls` la présence de `install.sh`, `nova.sh` et `themes/`, puis lancez le script Bash.

```bash
ls install.sh nova.sh themes
bash install.sh
```

Le programme installe `termux-tools` et `curl`, copie la commande `nova` et les thèmes, puis ajoute des hooks au démarrage dans `~/.bashrc`. Il demande la permission de désactiver les outils d'interface concurrents et crée des sauvegardes horodatées des fichiers rc si vous acceptez. Pour la restauration automatique : **Entrée = oui**, `n` = non. Le thème initial est `nova-dark`. Ouvrez une nouvelle session Termux ou exécutez `source ~/.bashrc` dans Bash.

```bash
source ~/.bashrc
```

**Attention :** lisez la question avant de désactiver les autres outils d'interface. L'installateur commente les lignes correspondantes des fichiers rc. Sauvegardez séparément les réglages importants.

## 05 — Verify and configure

**4. Vérifier et ouvrir le menu.** `nova doctor` affiche un diagnostic ; `nova console` ouvre le menu numéroté. `nova list` liste les thèmes et `nova current` affiche la configuration.

```bash
command -v nova
nova doctor
nova console
nova list
nova current
```

## 06 — Themes and startup

**5. Thèmes et démarrage.** `nova set dracula` change les couleurs ; `nova auto on` restaure le thème choisi au démarrage suivant. La grande bannière peut apparaître au démarrage et après `clear` ; réglez ces options dans `nova console`. Nova ne modifie pas les boutons natifs d'Android.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 07 — Custom commands: create, read, update, delete

**6. Créer des commandes personnalisées (CRUD).** Le déclencheur peut commencer par le nom d'un exécutable installé. `///` sépare les étapes ; chaque étape suivante démarre seulement si la précédente réussit. L'exemple nécessite Git.

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

**7. Mettre à jour.** Dans le dépôt cloné, exécutez `git pull --ff-only`, puis `bash install.sh`. Les modifications locales peuvent bloquer la mise à jour ; sauvegardez-les d'abord. L'installation peut reposer certaines questions.

```bash
cd ~/termux-nova
git status
git pull --ff-only
bash install.sh
source ~/.bashrc
nova doctor
```

## 09 — Troubleshooting

**8. Dépannage.**

1. `nova: command not found` — relancez `bash install.sh`, vérifiez `command -v nova` et ouvrez une nouvelle session.
2. Les couleurs ne changent pas — exécutez `pkg install -y termux-tools`, puis `nova set dracula` ; relancez l'application.
3. Le thème se réinitialise — vérifiez `nova current` et activez `nova auto on`.
4. Une commande personnalisée ne fonctionne pas — vérifiez `nova cmd`, puis exécutez `source ~/.bashrc`.
5. L'ancien prompt a disparu — vérifiez les sauvegardes `~/.bashrc.nova-backup-*` ; `nova restore` remplace entièrement `.bashrc` par la sauvegarde la plus récente et peut écraser les modifications ultérieures.

## 10 — Uninstall and privacy

**9. Désinstaller et gérer les données.** Désactivez la restauration automatique, retirez les hooks Nova de `.bashrc` et supprimez la commande installée. La dernière ligne efface **définitivement** paramètres, commandes personnelles et cache ; ignorez-la si vous souhaitez conserver ces données.

```bash
nova auto off
sed -i '/# termux-nova$/d' ~/.bashrc
sed -i '/# termux-nova$/d' ~/.bash_profile
rm -f "$PREFIX/bin/nova"
# OPTIONAL — irreversible data deletion:
rm -rf ~/.config/termux-nova ~/.cache/termux-nova
```

Les commandes personnelles sont dans `~/.config/termux-nova/commands`. N'y inscrivez ni mots de passe ni jetons : ils restent dans un fichier local et sont exécutables. Cette version ne fournit pas encore les statistiques SQLite ni les suggestions de type ghost-text.

---

**Auteur :** rugo · [RuslanSharifov](https://github.com/RuslanSharifov). [Toutes les langues et plateformes](../README.md).
