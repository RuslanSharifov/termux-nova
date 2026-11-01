# Termux Nova — installation dans Android Termux

[← README et démo](../../README.md) · [Guide Windows CMD](../cmd/SETUP.fr.md)

## 1. Installation — un seul copier-coller

**Copiez tout le bloc ci-dessous et collez-le une seule fois dans Termux.** Il télécharge le dépôt, installe Nova et termine par `clear`.

```bash
pkg update -y && pkg install -y git && \
cd "$HOME" && \
git clone https://github.com/RuslanSharifov/termux-nova.git && \
cd termux-nova && \
bash install.sh && \
source "$HOME/.bashrc" && \
clear
```

L'installation peut demander de désactiver d'autres outils d'interface et d'activer la restauration automatique du thème. Lisez les questions ; **Entrée = oui** pour la restauration automatique. Nova se chargera ensuite automatiquement dans les nouvelles sessions interactives Termux.

> Si `~/termux-nova` existe déjà, `git clone` s'arrête. Utilisez plutôt la section **Mise à jour** ci-dessous.

## 2. Utiliser Nova

Rouvrez Termux après l'installation ou utilisez les commandes suivantes. Le menu des réglages s'ouvre avec `nova console`.

```bash
nova console
nova list
nova current
nova doctor
```

## 3. Thèmes et démarrage

Thèmes intégrés : `nova-dark`, `dracula`, `nord`, `gruvbox`. `nova auto on` restaure le thème enregistré lors des nouvelles sessions. Les bannières au démarrage et après `clear` se règlent dans `nova console`.

```bash
nova set dracula
nova set nord
nova set gruvbox
nova set nova-dark
nova auto on
nova banner
```

## 4. Commandes personnalisées — ajouter, lister, modifier, supprimer

`///` sépare les étapes séquentielles. La suivante s'exécute seulement si la précédente réussit. L'exemple utilise Git (installé pendant la configuration).

```bash
nova cmd add "git quick" "git status /// git log -1 --oneline"
nova cmd
nova cmd edit "git quick" "git status --short"
nova cmd rm "git quick"
```

Après toute modification, rouvrez Termux ou lancez `source ~/.bashrc`. Ne stockez ni mots de passe ni jetons dans les commandes.

## 5. Mettre à jour une installation existante

Si le dépôt est déjà cloné, inutile de le cloner à nouveau. Collez ce bloc de mise à jour. Les questions d'installation peuvent réapparaître.

```bash
cd ~/termux-nova && git pull --ff-only && bash install.sh && source ~/.bashrc && clear
```

## 6. Dépannage

1. **`nova: command not found`** — rouvrez Termux ; au besoin, `cd ~/termux-nova && bash install.sh`.
2. **Les couleurs ne changent pas** — lancez `pkg install -y termux-tools`, puis `nova set dracula`.
3. **Le thème se réinitialise** — vérifiez `nova current` et activez `nova auto on`.
4. **La commande personnelle ne fonctionne pas** — vérifiez `nova cmd`, puis lancez `source ~/.bashrc`.
5. **L'ancien prompt a changé** — consultez les fichiers `.nova-backup-*`. `nova restore` remplace entièrement `~/.bashrc` par la dernière sauvegarde et peut supprimer des modifications ultérieures.

## 7. Désinstallation et sécurité

Ce bloc désactive la restauration automatique et supprime les hooks de démarrage et la commande Nova. Il ne restaure pas automatiquement les anciennes couleurs du terminal.

```bash
nova auto off
[ -f "$HOME/.bashrc" ] && sed -i '/# termux-nova$/d' "$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && sed -i '/# termux-nova$/d' "$HOME/.bash_profile"
rm -f "$PREFIX/bin/nova"
```

**Suppression définitive facultative des données :** sauvegardez d'abord ce dont vous avez besoin, puis lancez `rm -rf ~/.config/termux-nova ~/.cache/termux-nova`.

**Note :** cette version Bash gère les thèmes et les commandes personnalisées. Les statistiques SQLite, les suggestions en texte grisé et l'acceptation avec Tab ne sont pas encore implémentées. Les menus et boutons Android ne sont pas modifiés.

---

Créé par **rugo · Ruslan Sharifov**. · [GitHub](https://github.com/RuslanSharifov/termux-nova)
