#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export HOME
HOME="$(mktemp -d)"
trap 'rm -rf "$HOME"' EXIT
export LC_CTYPE=C.UTF-8
mkdir -p "$HOME/.config/termux-nova" "$HOME/.cache/termux-nova"
cp "$ROOT/assets/banner-font.txt" "$HOME/.config/termux-nova/banner-font.txt"
printf '{}\n' > "$HOME/.cache/termux-nova/repo.json"

nova() { bash "$ROOT/nova.sh" "$@"; }

# All printable ASCII glyphs, A-Z, a-z, digits, punctuation.
for n in $(seq 32 126); do
  printf -v hex '%04X' "$n"
  grep -q "^$hex|" "$ROOT/assets/banner-font.txt" || {
    echo "Missing ASCII glyph: $hex" >&2
    exit 1
  }
done

nova banner set 'A&B|C/#? 123' > "$HOME/output"
grep -Fqx 'BANNER_TEXT=A&B|C/#? 123' "$HOME/.config/termux-nova/config"
nova banner > "$HOME/output"
grep -q '█' "$HOME/output"

nova banner set 'ƏŞĞİ 123' > "$HOME/output"
grep -Fqx 'BANNER_TEXT=ƏŞĞİ 123' "$HOME/.config/termux-nova/config"
nova banner > "$HOME/output"
grep -q '█' "$HOME/output"

nova banner reset > "$HOME/output"
grep -Fqx 'BANNER_TEXT=NOVA' "$HOME/.config/termux-nova/config"
grep -q '███╗' "$HOME/output"

if nova banner set $'unsafe\nnewline' >/dev/null 2>&1; then
  echo 'Control characters should be rejected' >&2
  exit 1
fi

nova banner set 'Saved 2026!' >/dev/null
nova current > "$HOME/output"
grep -q 'Banner text' "$HOME/output"

echo 'Banner tests passed.'
