#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
#  termux-nova - Termux UI theme switcher & command manager
#  by rugo - MIT License
# ============================================================

NOVA_VERSION="2.1.0"
NOVA_OWNER="RuslanSharifov"
NOVA_REPO="RuslanSharifov/termux-nova"
REPO_TTL=21600   # refresh GitHub stats every 6 hours
NOVA_HOME="$HOME/.config/termux-nova"
NOVA_THEMES="$NOVA_HOME/themes"
NOVA_CONF="$NOVA_HOME/config"
NOVA_CMDS="$NOVA_HOME/commands"
NOVA_CACHE="$HOME/.cache/termux-nova"
NOVA_ALIASES="$NOVA_CACHE/aliases.sh"
REPO_CACHE="$NOVA_CACHE/repo.json"
TERMUX_HOME="$HOME/.termux"
TERMUX_COLORS="$TERMUX_HOME/colors.properties"

# Lines written into ~/.bashrc (all end with the marker "# termux-nova")
HOOK_LINES=(
  'command -v nova >/dev/null 2>&1 && nova --auto  # termux-nova'
  'clear() { printf "\033[H\033[2J\033[3J"; command -v nova >/dev/null 2>&1 && nova --clear-hook; }  # termux-nova'
  '[ -f "$HOME/.cache/termux-nova/aliases.sh" ] && . "$HOME/.cache/termux-nova/aliases.sh"  # termux-nova'
  'case $- in *i*) if [ -z "${__NOVA_STARTED:-}" ]; then __NOVA_STARTED=1; printf "\033[H\033[2J\033[3J"; command -v nova >/dev/null 2>&1 && nova --start; fi ;; esac  # termux-nova'
)

if [ -t 1 ]; then
  C_RST=$'\033[0m'; C_B=$'\033[1m'; C_CY=$'\033[36m'; C_GR=$'\033[32m'
  C_RD=$'\033[31m'; C_MG=$'\033[35m'; C_DM=$'\033[2m'; C_YE=$'\033[33m'
else
  C_RST=""; C_B=""; C_CY=""; C_GR=""; C_RD=""; C_MG=""; C_DM=""; C_YE=""
fi

FRAMES=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)

ok()   { printf '%s✔%s %s\n' "$C_GR" "$C_RST" "$*"; }
err()  { printf '%s✘%s %s\n' "$C_RD" "$C_RST" "$*"; }

show_banner() {
  printf '%s' "$C_CY$C_B"
  cat <<'BANNER'
 ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗
 ████╗  ██║██╔═══██╗██║   ██║██╔══██╗
 ██╔██╗ ██║██║   ██║██║   ██║███████║
 ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║
 ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║
 ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝
BANNER
  printf '%s' "$C_RST"
  printf '%s   Termux UI Theme Switcher  v%s  by rugo%s\n' "$C_DM" "$NOVA_VERSION" "$C_RST"
  show_repo_block
  echo
}

# ---------- GitHub repo stats (cached, refreshed in background) ----------
repo_field() {   # repo_field <json key>  -> number
  [ -s "$REPO_CACHE" ] || return 0
  sed -n "s/.*\"$1\": *\([0-9][0-9]*\).*/\1/p" "$REPO_CACHE" | head -n1
}

repo_pushed() {
  [ -s "$REPO_CACHE" ] || return 0
  sed -n 's/.*"pushed_at": *"\([0-9-]*\)T.*/\1/p' "$REPO_CACHE" | head -n1
}

repo_cache_stale() {
  [ -f "$REPO_CACHE" ] || return 0
  local now mtime
  now="$(date +%s)"
  mtime="$(stat -c %Y "$REPO_CACHE" 2>/dev/null || stat -f %m "$REPO_CACHE" 2>/dev/null || echo 0)"
  [ $(( now - mtime )) -gt "$REPO_TTL" ]
}

refresh_repo_stats() {
  local tmp="$REPO_CACHE.tmp"
  curl -fsSL --max-time 10 -H "Accept: application/vnd.github+json" \
    "https://api.github.com/repos/$NOVA_REPO" -o "$tmp" 2>/dev/null \
    && grep -q '"stargazers_count"' "$tmp" \
    && mv "$tmp" "$REPO_CACHE"
  rm -f "$tmp"
}

show_repo_block() {
  if repo_cache_stale; then
    mkdir -p "$NOVA_CACHE"
    touch "$REPO_CACHE"
    ( refresh_repo_stats ) >/dev/null 2>&1 &
  fi
  local stars forks issues pushed
  stars="$(repo_field stargazers_count)"
  forks="$(repo_field forks_count)"
  issues="$(repo_field open_issues_count)"
  pushed="$(repo_pushed)"
  printf '%s   GitHub  : github.com/%s%s\n' "$C_DM" "$NOVA_OWNER" "$C_RST"
  printf '%s   Repo    : github.com/%s%s\n' "$C_DM" "$NOVA_REPO" "$C_RST"
  printf '   %s★%s %s stars   %s⑂%s %s forks   %s●%s %s issues   %s↻%s %s\n' \
    "$C_YE" "$C_RST" "${stars:-…}" \
    "$C_CY" "$C_RST" "${forks:-…}" \
    "$C_GR" "$C_RST" "${issues:-…}" \
    "$C_MG" "$C_RST" "${pushed:-…}"
}

# ---------- settings ----------
conf_get() {   # conf_get KEY [default]
  local v=""
  [ -f "$NOVA_CONF" ] && v="$(sed -n "s/^$1=//p" "$NOVA_CONF" | tail -n1)"
  echo "${v:-$2}"
}

conf_set() {
  mkdir -p "$NOVA_HOME"
  touch "$NOVA_CONF"
  if grep -q "^$1=" "$NOVA_CONF"; then
    sed -i "s|^$1=.*|$1=$2|" "$NOVA_CONF"
  else
    echo "$1=$2" >> "$NOVA_CONF"
  fi
}

toggle_conf() {  # toggle_conf KEY  (default on)
  if [ "$(conf_get "$1" on)" = "on" ]; then conf_set "$1" off; else conf_set "$1" on; fi
}

reset_settings() {
  rm -f "$NOVA_CONF"
  conf_set THEME nova-dark
  conf_set AUTO on
  conf_set BANNER_ON_START on
  conf_set BANNER_ON_CLEAR on
}

# ---------- ~/.bashrc hook ----------
ensure_hook() {
  local rc="$HOME/.bashrc" prof="$HOME/.bash_profile" line
  touch "$rc"
  sed -i '/# termux-nova$/d' "$rc"
  for line in "${HOOK_LINES[@]}"; do
    echo "$line" >> "$rc"
  done
  # Login shells read ~/.bash_profile first and may skip ~/.bashrc
  touch "$prof"
  if ! grep -q 'termux-nova' "$prof"; then
    echo '[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"  # termux-nova' >> "$prof"
  fi
}

# ---------- loader ----------
run_with_loader() {
  local msg="$1"; shift
  "$@" >/dev/null 2>&1 &
  local pid=$! i=0
  while kill -0 "$pid" 2>/dev/null; do
    printf '\r%s%s%s %s   ' "$C_MG" "${FRAMES[i]}" "$C_RST" "$msg"
    i=$(( (i + 1) % ${#FRAMES[@]} ))
    sleep 0.08
  done
  wait "$pid"
  local rc=$?
  if [ $rc -eq 0 ]; then
    printf '\r%s✔%s %s          \n' "$C_GR" "$C_RST" "$msg"
  else
    printf '\r%s✘%s %s          \n' "$C_RD" "$C_RST" "$msg"
  fi
  return $rc
}

# ---------- themes ----------
_apply_colors() {
  mkdir -p "$TERMUX_HOME"
  cp "$1" "$TERMUX_COLORS" || return 1
  if command -v termux-reload-settings >/dev/null 2>&1; then
    termux-reload-settings
  fi
  return 0
}

theme_exists() { [ -f "$NOVA_THEMES/$1.properties" ]; }

theme_names() {
  local f
  for f in "$NOVA_THEMES"/*.properties; do
    [ -f "$f" ] && basename "$f" .properties
  done
}

list_themes() {
  local active id mark
  active="$(conf_get THEME nova-dark)"
  echo "Available themes:"
  while read -r id; do
    [ -n "$id" ] || continue
    mark=" "
    [ "$id" = "$active" ] && mark="${C_GR}●${C_RST}"
    printf '  %s %s\n' "$mark" "$id"
  done < <(theme_names)
}

set_theme() {
  local id="$1"
  if ! theme_exists "$id"; then
    err "Unknown theme: $id"
    list_themes
    return 1
  fi
  run_with_loader "Applying theme: $id" _apply_colors "$NOVA_THEMES/$id.properties" || return 1
  conf_set THEME "$id"
  ok "Theme saved: $id"
}

auto_apply() {
  [ "$(conf_get AUTO on)" = "on" ] || return 0
  local id
  id="$(conf_get THEME nova-dark)"
  theme_exists "$id" || return 0
  cmp -s "$NOVA_THEMES/$id.properties" "$TERMUX_COLORS" && return 0
  _apply_colors "$NOVA_THEMES/$id.properties" >/dev/null 2>&1
  return 0
}

# ---------- custom commands (CRUD) ----------
# Stored as: TRIGGER<TAB>COMMAND   e.g.  npm run full<TAB>npm i && npm run dev

trim() {
  local s="$*"
  s="${s#"${s%%[![:space:]]*}"}"
  s="${s%"${s##*[![:space:]]}"}"
  printf '%s' "$s"
}

# "npm i /// npm run dev" -> "npm i && npm run dev"
normalize_steps() {
  local input="$1" out="" part
  while [[ "$input" == *"///"* ]]; do
    part="$(trim "${input%%///*}")"
    input="${input#*///}"
    if [ -n "$part" ]; then out="${out:+$out && }$part"; fi
  done
  part="$(trim "$input")"
  if [ -n "$part" ]; then out="${out:+$out && }$part"; fi
  printf '%s' "$out"
}

cmd_key_valid() {
  local key="$1" first
  [[ "$key" == *"///"* ]] && return 1
  first="${key%% *}"
  [[ "$first" =~ ^[A-Za-z_][A-Za-z0-9_.-]*$ ]] || return 1
  case "$first" in
    cd|ls|clear|nova|exit|source|alias|echo|export|set|unset|exec|eval|return|command|builtin)
      return 1 ;;
  esac
  return 0
}

cmd_exists() {
  [ -f "$NOVA_CMDS" ] || return 1
  NOVA_K="$1" awk -F'\t' '$1==ENVIRON["NOVA_K"]{f=1} END{exit !f}' "$NOVA_CMDS"
}

cmd_get() {
  [ -f "$NOVA_CMDS" ] || return 0
  NOVA_K="$1" awk -F'\t' '$1==ENVIRON["NOVA_K"]{print $2; exit}' "$NOVA_CMDS"
}

cmd_count() {
  if [ -f "$NOVA_CMDS" ]; then wc -l < "$NOVA_CMDS" | tr -d ' '; else echo 0; fi
}

cmd_create() {   # CREATE
  local key cmd
  key="$(trim "$1")"; cmd="$(trim "$2")"
  cmd_key_valid "$key" || { err "Trigger must look like 'npm run full' (first word = a normal command name)"; return 1; }
  [ -n "$cmd" ] || { err "Command is empty"; return 1; }
  if cmd_exists "$key"; then err "'$key' already exists. Use: nova cmd edit"; return 1; fi
  mkdir -p "$NOVA_HOME"
  printf '%s\t%s\n' "$key" "$cmd" >> "$NOVA_CMDS"
  rebuild_aliases
  ok "Added: $key"
  echo "   Open a new session or run: source ~/.bashrc"
}

cmd_read() {     # READ
  if [ ! -f "$NOVA_CMDS" ] || [ "$(cmd_count)" = "0" ]; then
    echo "No custom commands yet."
    return 0
  fi
  awk -F'\t' '{printf "  %s  ->  %s\n", $1, $2}' "$NOVA_CMDS"
}

cmd_update() {   # UPDATE
  local key cmd
  key="$(trim "$1")"; cmd="$(trim "$2")"
  cmd_exists "$key" || { err "No such command: $key"; return 1; }
  [ -n "$cmd" ] || { err "Command is empty"; return 1; }
  NOVA_K="$key" NOVA_C="$cmd" awk -F'\t' -v OFS='\t' \
    '$1==ENVIRON["NOVA_K"]{$2=ENVIRON["NOVA_C"]} {print}' "$NOVA_CMDS" > "$NOVA_CMDS.tmp" \
    && mv "$NOVA_CMDS.tmp" "$NOVA_CMDS"
  rebuild_aliases
  ok "Updated: $key"
}

cmd_delete() {   # DELETE
  local key="$1"
  cmd_exists "$key" || { err "No such command: $key"; return 1; }
  NOVA_K="$key" awk -F'\t' '$1!=ENVIRON["NOVA_K"]' "$NOVA_CMDS" > "$NOVA_CMDS.tmp" \
    && mv "$NOVA_CMDS.tmp" "$NOVA_CMDS"
  rebuild_aliases
  ok "Deleted: $key"
}

# Generates shell wrapper functions (e.g. npm()) so that typing the trigger runs the chain
rebuild_aliases() {
  mkdir -p "$NOVA_CACHE"
  touch "$NOVA_CMDS"
  local tmp="$NOVA_ALIASES.tmp" first key cmd rest
  {
    echo "# generated by termux-nova (by rugo) - do not edit"
    cut -f1 "$NOVA_CMDS" | awk '{print $1}' | sort -u | while read -r first; do
      [ -n "$first" ] || continue
      printf '%s() {\n  case "$*" in\n' "$first"
      while IFS=$'\t' read -r key cmd; do
        [ -n "$key" ] || continue
        [ "${key%% *}" = "$first" ] || continue
        if [ "$key" = "$first" ]; then rest=""; else rest="${key#* }"; fi
        printf '    %s) nova --run %s; return $? ;;\n' "$(printf '%q' "$rest")" "$(printf '%q' "$key")"
      done < "$NOVA_CMDS"
      printf '  esac\n  command %s "$@"\n}\n' "$first"
    done
  } > "$tmp"
  mv "$tmp" "$NOVA_ALIASES"
}

run_custom() {
  local key="$1" cmd
  cmd="$(cmd_get "$key")"
  if [ -z "$cmd" ]; then err "Unknown command: $key"; return 1; fi
  printf '%s▶%s %s\n' "$C_CY" "$C_RST" "$cmd"
  bash -c "$cmd"
}

# ---------- cache ----------
cache_clear() {
  rm -rf "$NOVA_CACHE"
  rebuild_aliases
  ok "Cache cleared (generated command wrappers rebuilt)"
}

# ---------- auto / restore ----------
restore_rc() {
  local latest
  latest="$(ls -1t "$HOME"/.bashrc.nova-backup-* 2>/dev/null | head -n1)"
  if [ -z "$latest" ]; then err "No backup found."; return 1; fi
  cp "$latest" "$HOME/.bashrc"
  ok "Restored ~/.bashrc from $latest"
  echo "Open a new Termux session for the change to take effect."
}

# ---------- console (settings / burger panel) ----------
pause() { echo; read -r -p "Press Enter to continue..." _; }

pick_theme() {
  local names=() id n i=1 choice
  while read -r id; do [ -n "$id" ] && names+=("$id"); done < <(theme_names)
  if [ "${#names[@]}" -eq 0 ]; then err "No themes found"; return; fi
  for id in "${names[@]}"; do printf '  %d) %s\n' "$i" "$id"; i=$((i + 1)); done
  read -r -p "Theme number: " choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#names[@]}" ]; then
    set_theme "${names[$((choice - 1))]}"
  else
    err "Invalid choice"
  fi
}

# Asks for steps (one line, separated by ///), then y / n / e confirmation.
save_flow() {   # save_flow add|edit KEY PREFILL
  local mode="$1" key="$2" raw="$3" joined ans
  if [ "$mode" = "add" ]; then
    cmd_key_valid "$key" || { err "Invalid trigger. Use 'salam' or 'npm run full'. Do not put /// in the trigger (///  is only for steps)."; return 1; }
    if cmd_exists "$key"; then err "'$key' already exists. Use Edit instead."; return 1; fi
  fi
  while true; do
    echo "Write all steps on ONE line, separated with ///"
    echo "Example: npm i /// npm run dev"
    read -e -r -i "$raw" -p "Steps: " raw
    joined="$(normalize_steps "$raw")"
    if [ -z "$joined" ]; then err "Steps cannot be empty."; continue; fi
    echo
    echo "  Trigger : $key"
    echo "  Runs    : $joined"
    echo
    while true; do
      read -r -p "Save? [y]es / [n]o / [e]dit: " ans
      case "$ans" in
        y|Y|yes)
          if [ "$mode" = "add" ]; then cmd_create "$key" "$joined"; else cmd_update "$key" "$joined"; fi
          return $? ;;
        n|N|no)
          echo "Cancelled."; return 0 ;;
        e|E|edit)
          raw="$(printf '%s' "$joined" | sed 's/ && / \/\/\/ /g')"
          break ;;
        *) echo "Please type y, n or e." ;;
      esac
    done
  done
}

commands_menu() {
  local key cur sure c
  while true; do
    command clear
    show_banner
    echo "Custom commands:"
    cmd_read
    echo
    echo " 1) Add   2) Edit   3) Delete   0) Back"
    read -r -p "Select: " c
    case "$c" in
      1)
        read -r -p "Trigger (e.g. salam or npm run full): " key
        save_flow add "$(trim "$key")" ""
        pause ;;
      2)
        read -r -p "Trigger to edit: " key
        key="$(trim "$key")"
        if ! cmd_exists "$key"; then err "No such command: $key"; pause; continue; fi
        cur="$(cmd_get "$key")"
        save_flow edit "$key" "$(printf '%s' "$cur" | sed 's/ && / \/\/\/ /g')"
        pause ;;
      3)
        read -r -p "Trigger to delete: " key
        read -r -p "Are you sure? [y/N] " sure
        case "$sure" in y|Y|yes) cmd_delete "$(trim "$key")" ;; *) echo "Cancelled." ;; esac
        pause ;;
      0|"") return ;;
      *) err "Invalid choice"; pause ;;
    esac
  done
}

console() {
  local c
  while true; do
    command clear
    show_banner
    printf '  Theme              : %s\n' "$(conf_get THEME nova-dark)"
    printf '  Auto restore       : %s\n' "$(conf_get AUTO on)"
    printf '  Banner on start    : %s\n' "$(conf_get BANNER_ON_START on)"
    printf '  Banner on clear    : %s\n' "$(conf_get BANNER_ON_CLEAR on)"
    printf '  Custom commands    : %s\n' "$(cmd_count)"
    echo
    echo "  1) Change theme"
    echo "  2) Toggle auto restore"
    echo "  3) Toggle banner on start"
    echo "  4) Toggle banner on clear"
    echo "  5) Custom commands (add / edit / delete)"
    echo "  6) Clear cache"
    echo "  7) Reset settings to defaults"
    echo "  8) Restore ~/.bashrc from backup"
    echo "  0) Exit"
    echo
    read -r -p "Select: " c
    case "$c" in
      1) echo; pick_theme; pause ;;
      2) toggle_conf AUTO; [ "$(conf_get AUTO)" = "on" ] && ensure_hook; ok "Auto restore: $(conf_get AUTO)"; pause ;;
      3) toggle_conf BANNER_ON_START; ok "Banner on start: $(conf_get BANNER_ON_START)"; pause ;;
      4) toggle_conf BANNER_ON_CLEAR; ok "Banner on clear: $(conf_get BANNER_ON_CLEAR)"; pause ;;
      5) commands_menu ;;
      6) echo; cache_clear; pause ;;
      7) read -r -p "Reset settings? (custom commands are kept) [y/N] " sure
         case "$sure" in y|Y|yes) reset_settings; ok "Settings reset"; ;; *) echo "Cancelled."; esac
         pause ;;
      8) echo; restore_rc; pause ;;
      0|"") command clear; return ;;
      *) err "Invalid choice"; pause ;;
    esac
  done
}

# ---------- CLI ----------
usage() {
cat <<EOF
Usage: nova <command>

  console                      open the settings panel (menu)
  list                         show all themes (● = active)
  set <theme>                  apply a theme and remember it
  current                      show all current settings
  auto on|off                  restore the saved theme on every start
  banner                       show the banner now
  cmd                          list custom commands
  cmd add "<trigger>" "<cmd>"  e.g. nova cmd add "npm run full" "npm i && npm run dev"
  cmd edit "<trigger>" "<cmd>"
  cmd rm "<trigger>"
  cache clear                  clear cache and rebuild command wrappers
  hook                         (re)install ~/.bashrc hooks
  restore                      restore ~/.bashrc from the install.sh backup
  help                         show this screen

EOF
}

main() {
  local cmd="${1:-help}"
  shift 2>/dev/null || true
  case "$cmd" in
    --auto)        auto_apply ;;
    --start)       [ "$(conf_get BANNER_ON_START on)" = "on" ] && show_banner ;;
    --clear-hook)  [ "$(conf_get BANNER_ON_CLEAR on)" = "on" ] && show_banner ;;
    --run)         run_custom "$1" ;;
    --banner|banner) show_banner ;;
    console|menu)  console ;;
    list)
      show_banner; list_themes ;;
    set)
      show_banner
      if [ -z "$1" ]; then echo "Usage: nova set <theme>"; exit 1; fi
      set_theme "$1" ;;
    current)
      show_banner
      echo "Theme              : $(conf_get THEME nova-dark)"
      echo "Auto restore       : $(conf_get AUTO on)"
      echo "Banner on start    : $(conf_get BANNER_ON_START on)"
      echo "Banner on clear    : $(conf_get BANNER_ON_CLEAR on)"
      echo "Custom commands    : $(cmd_count)" ;;
    auto)
      show_banner
      case "$1" in
        on)  conf_set AUTO on;  ensure_hook; ok "Auto restore enabled" ;;
        off) conf_set AUTO off; ensure_hook; ok "Auto restore disabled" ;;
        *)   echo "Usage: nova auto on|off"; exit 1 ;;
      esac ;;
    cmd)
      show_banner
      case "$1" in
        ""|list) cmd_read ;;
        add)     cmd_create "$2" "$(normalize_steps "$3")" ;;
        edit)    cmd_update "$2" "$(normalize_steps "$3")" ;;
        rm|delete) cmd_delete "$2" ;;
        *)       echo 'Usage: nova cmd [list|add|edit|rm] ...'; exit 1 ;;
      esac ;;
    cache)
      show_banner
      case "$1" in
        clear) cache_clear ;;
        *)     echo "Usage: nova cache clear"; exit 1 ;;
      esac ;;
    hook)
      ensure_hook; ok "Hooks installed. 'clear' shows the banner; new sessions start with a clear + banner." ;;
    restore)
      show_banner; restore_rc ;;
    doctor)
      show_banner
      echo "nova in PATH  : $(command -v nova || echo 'NO')"
      echo "PREFIX        : ${PREFIX:-<unset>}"
      echo "bashrc hooks  : $(grep -c '# termux-nova$' "$HOME/.bashrc" 2>/dev/null || echo 0) line(s)"
      echo "banner start  : $(conf_get BANNER_ON_START on)"
      echo "banner clear  : $(conf_get BANNER_ON_CLEAR on)"
      echo "aliases.sh    : $([ -f "$NOVA_ALIASES" ] && echo ok || echo 'not created yet (add a command first)')"
      echo "bash_profile  : $(grep -q 'termux-nova' "$HOME/.bash_profile" 2>/dev/null && echo ok || echo MISSING)"
      echo "custom cmds   : $(cmd_count)"
      echo "curl          : $(command -v curl || echo 'MISSING (pkg install curl)')"
      echo "repo stats    : $([ -s "$REPO_CACHE" ] && echo cached || echo 'not fetched yet')" ;;
    help|-h|--help)
      show_banner; usage ;;
    *)
      show_banner; err "Unknown command: $cmd"; echo; usage; exit 1 ;;
  esac
}

main "$@"
