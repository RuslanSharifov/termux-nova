#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  termux-nova installer - by rugo
# ============================================================
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"
BIN="$PREFIX/bin"
NOVA_HOME="$HOME/.config/termux-nova"
RC_FILES="$HOME/.bashrc $HOME/.bash_profile $HOME/.profile"

# Lines that load other prompt / UI tools. They are commented out (with backup).
OTHER_UI_PATTERN='starship init|oh-my-posh init|zoxide init|oh-my-zsh|powerlevel|^[[:space:]]*PS1=|^[[:space:]]*PROMPT=|PROMPT_COMMAND='

disable_other_ui() {
  local stamp f count=0
  stamp="$(date +%Y%m%d-%H%M%S)"
  for f in $RC_FILES; do
    [ -f "$f" ] || continue
    cp "$f" "$f.nova-backup-$stamp"
    echo "  backup: $f.nova-backup-$stamp"
    if grep -Eq "$OTHER_UI_PATTERN" "$f"; then
      sed -i -E "/$OTHER_UI_PATTERN/ s/^/# disabled by termux-nova: /" "$f"
      echo "  disabled other UI lines in $f"
      count=$((count + 1))
    fi
  done
  echo "  ✔ $count file(s) cleaned"
}

echo "== termux-nova installer by rugo =="
echo

echo "[1/6] Installing dependencies (termux-tools, curl)..."
pkg update -y >/dev/null 2>&1 || true
pkg install -y termux-tools curl

echo "[2/6] Copying files..."
mkdir -p "$NOVA_HOME/themes"
cp "$ROOT"/themes/*.properties "$NOVA_HOME/themes/"
cp "$ROOT/assets/banner-font.txt" "$NOVA_HOME/banner-font.txt"
cp "$ROOT/nova.sh" "$BIN/nova"
chmod +x "$BIN/nova"

echo "[3/6] Other prompt / UI tools"
read -r -p "Disable other UI tools (a backup of your rc files is made)? [Y/n] " ans || ans="y"
case "$ans" in
  n|N|no|NO) echo "  skipped" ;;
  *)         disable_other_ui ;;
esac

echo "[4/6] Hooks (auto restore, clear banner, command wrappers)"
nova hook

echo "[5/6] Auto restore"
read -r -p "Enable auto restore on every Termux start? [Y/n] " ans || ans="y"
case "$ans" in
  n|N|no|NO) nova auto off ;;
  *)         nova auto on ;;
esac

echo "[6/6] Applying default theme (nova-dark)..."
nova set nova-dark

echo
echo "Done! Open a new Termux session (or run: source ~/.bashrc)."
echo "Run 'nova console' to open the settings panel."
