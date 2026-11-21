#!/usr/bin/env bash
# =================================================================================================================
#  SpaceFleet launcher for Linux. Run it to play.
#
#  1. Make a new, empty folder (for example ~/Games/SpaceFleet) and put this file in it.
#  2. Open a terminal in that folder and run:   bash play-spacefleet.sh
#     (or once  chmod +x play-spacefleet.sh  and from then on  ./play-spacefleet.sh )
#  3. The first start downloads the newest game build (about 50 MB) into this folder and starts it. Every later
#     start checks for a newer build first; offline it starts the build you have.
#
#  Needs: bash, curl, tar and gzip, which a normal Ubuntu desktop already has. Nothing else to install:
#  the game carries its own .NET runtime, SDL2 and OpenAL. If zenity, yad or kdialog is installed you get a small
#  progress window, otherwise it prints what it does in the terminal.
#  Your saves and settings are in ~/.config/SpaceFleet (outside this folder), so updates never touch them.
#  To report a problem: say what happened and give the build number (printed when the launcher starts and shown at
#  the bottom-left of the main menu). The launcher's log is launcher/launcher.log, the game's output
#  launcher/game-last.log, both in this folder.
#
#  Ubuntu / Debian: instead of this file you can install spacefleet-launcher.deb from the same place
#  (sudo apt install ./spacefleet-launcher.deb). It puts this launcher in /usr/games/spacefleet and SpaceFleet in the
#  app menu; the game then goes to ~/.local/share/SpaceFleet.
# =================================================================================================================
#
# Folder layout (the folder this script is in):
#   play-spacefleet.sh (any name), launcher/launcher.log, launcher/game-last.log, (optional) launcher/launcher.conf
#   versions/<tag>/SpaceFleet.Game ...   the installed builds (the current one and the previous one)
#   current.txt, previous.txt            their tags
#   .dl/                                 temporary files of an update in progress (always safe to delete)
# Everything this script creates or deletes is inside that folder. Saves and settings live in ~/.config/SpaceFleet
# and are never touched. Arguments given to this script are passed to the game.
#
# The game build is the file SpaceFleet-linux.tar.gz on the main branch of the repo below (no login needed;
# launcher/launcher.conf with owner=... / repo=... lines overrides it). Every start asks the server for that file's
# ETag (a HEAD request) and downloads only when it differs from the one the installed build came from
# (current-download.txt). A newer launcher arrives inside a game build and is staged as "<this file>.new"; it is used
# from the next start.
# Closing the progress window (or its button) means "play now without updating". Ctrl+C in a terminal quits.
# Test overrides (not needed by players): SPACEFLEET_RAW_BASE (the address that holds SpaceFleet-linux.tar.gz,
# default https://github.com/<owner>/<repo>/raw/main), SPACEFLEET_UI=none|zenity|yad|kdialog,
# SPACEFLEET_NO_UPDATE=1 (start the installed build without asking GitHub).
set -u

SELF="$(readlink -f "$0" 2>/dev/null || echo "$0")"
SELFDIR="$(cd "$(dirname "$SELF")" && pwd)"
# Installed mode: the .deb puts this script in /usr/games, which the player cannot write. Then the game folder is
# $SPACEFLEET_GAME_DIR or ${XDG_DATA_HOME:-~/.local/share}/SpaceFleet, and once a build has been installed there the
# launcher copy that came with it (<game folder>/play-spacefleet.sh, always the newest) is what runs, so launcher
# updates reach .deb users without a new .deb and without root.
INSTALLED_MODE=0
if [ ! -w "$SELFDIR" ]; then
  INSTALLED_MODE=1
  ROOT="${SPACEFLEET_GAME_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/SpaceFleet}"
  mkdir -p "$ROOT" 2>/dev/null
  ROOT="$(cd "$ROOT" 2>/dev/null && pwd)" || { echo "SpaceFleet: cannot create the game folder $ROOT" >&2; exit 1; }
  if [ -z "${SF_DELEGATED:-}" ] && [ -f "$ROOT/play-spacefleet.sh" ] && bash -n "$ROOT/play-spacefleet.sh" 2>/dev/null; then
    SF_DELEGATED=1 exec bash "$ROOT/play-spacefleet.sh" "$@"
  fi
else
  ROOT="$SELFDIR"
fi
LDIR="$ROOT/launcher"
VERS="$ROOT/versions"
DL="$ROOT/.dl"
LOG="$LDIR/launcher.log"
EXE="SpaceFleet.Game"
ASSET="SpaceFleet-linux.tar.gz"
mkdir -p "$LDIR" 2>/dev/null

# ---- finish an earlier launcher self-update (a new script is staged as "<this file>.new"; swapping the file by
# rename is safe even though this very script is running: bash keeps the old file open)
if [ -f "$SELF.new" ] && [ -z "${SF_REEXEC:-}" ]; then
  if bash -n "$SELF.new" 2>/dev/null && mv -f "$SELF.new" "$SELF" 2>/dev/null; then
    chmod +x "$SELF" 2>/dev/null
    SF_REEXEC=1 exec bash "$SELF" "$@"
  fi
fi

log() { printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" >> "$LOG" 2>/dev/null; }
if [ -f "$LOG" ] && [ "$(stat -c %s "$LOG" 2>/dev/null || echo 0)" -gt 200000 ]; then rm -f "$LOG"; fi
log "---- launcher started ($SELF)"

# ---- one launcher at a time per folder
if command -v flock >/dev/null 2>&1; then
  exec 9> "$ROOT/.lock"
  flock -n 9 || { log "Another launcher is already running for this folder; exiting"; exit 0; }
fi

# ---- config
OWNER="StarkBotha"; REPO="spacefleet-releases"   # @public-repo@ (set by build-launchers.sh)
if [ -f "$LDIR/launcher.conf" ]; then
  v="$(sed -n 's/^owner=\([A-Za-z0-9._-]*\)[[:space:]]*$/\1/p' "$LDIR/launcher.conf" | head -n1)"; [ -n "$v" ] && OWNER="$v"
  v="$(sed -n 's/^repo=\([A-Za-z0-9._-]*\)[[:space:]]*$/\1/p' "$LDIR/launcher.conf" | head -n1)"; [ -n "$v" ] && REPO="$v"
fi
RAW="https://github.com/$OWNER/$REPO/raw/main"
if [ -n "${SPACEFLEET_RAW_BASE:-}" ]; then RAW="${SPACEFLEET_RAW_BASE%/}"; fi
UA="SpaceFleetLauncher"

# ---- file safety: the only places anything is deleted are inside versions/ and .dl/
valid_tag() { [[ "$1" =~ ^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$ ]]; }
safe_rm() {
  local p="$1"
  case "$p" in
    *..*) log "REFUSED to delete (contains ..): $p"; return 1 ;;
    "$VERS"/?*|"$DL"/?*|"$DL") ;;
    *) log "REFUSED to delete outside the install folder: $p"; return 1 ;;
  esac
  [ -e "$p" ] || [ -L "$p" ] || return 0
  rm -rf -- "$p" 2>/dev/null || { log "Could not delete $p"; return 1; }
}
read_tag() {   # read_tag current.txt -> prints the tag if valid and installed
  local f="$ROOT/$1" t
  [ -f "$f" ] || return 1
  t="$(tr -d ' \t\r\n' < "$f" 2>/dev/null)"
  valid_tag "$t" || return 1
  [ -f "$VERS/$t/$EXE" ] || return 1
  printf '%s' "$t"
}
installed_tag() { read_tag current.txt || read_tag previous.txt; }

# ---- UI: zenity/yad (same protocol), kdialog, or the terminal
UI="none"; ZPID=""; KREF=""
if [ -n "${SPACEFLEET_UI:-}" ]; then UI="$SPACEFLEET_UI"
elif [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ]; then
  if command -v zenity >/dev/null 2>&1; then UI=zenity
  elif command -v yad >/dev/null 2>&1; then UI=yad
  elif command -v kdialog >/dev/null 2>&1 && command -v qdbus >/dev/null 2>&1; then UI=kdialog
  fi
fi
UIFIFO=""
# Started from the app menu with no progress-window tool and no terminal: desktop notifications (notify-send) for the
# download and for errors; otherwise only the log.
NOTIFY=0
if [ "$UI" = none ] && [ ! -t 1 ] && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] && command -v notify-send >/dev/null 2>&1; then NOTIFY=1; fi
# UI_SHOWN=1 only while a progress window really exists. "The player closed the window" (= play now without
# updating) is only ever concluded from a window that was shown and then disappeared: with no window at all (no
# zenity/yad/kdialog, started from the app menu or with the output redirected) the launcher carries on by itself.
UI_SHOWN=0
ui_open() {
  case "$UI" in
    zenity|yad)
      mkdir -p "$DL"; UIFIFO="$DL/ui.fifo"; rm -f "$UIFIFO"
      if mkfifo "$UIFIFO" 2>/dev/null; then
        "$UI" --progress --title="SpaceFleet" --text="Checking for updates..." --percentage=0 --width=460 --auto-close \
          < "$UIFIFO" >/dev/null 2>&1 &
        ZPID=$!
        exec 3<> "$UIFIFO"   # read-write: never blocks, even if the window tool failed to start
        sleep 0.5
        if kill -0 "$ZPID" 2>/dev/null; then UI_SHOWN=1; else log "The $UI window did not open; carrying on without it"; exec 3>&- 2>/dev/null; rm -f "$UIFIFO"; UI=none; fi
      else UI=none; fi ;;
    kdialog)
      if KREF="$(kdialog --title SpaceFleet --progressbar "Checking for updates..." 100 2>/dev/null)" && [ -n "$KREF" ]; then UI_SHOWN=1; else UI=none; fi ;;
  esac
  if [ "$UI" = none ] && [ ! -t 1 ] && [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] && command -v notify-send >/dev/null 2>&1; then NOTIFY=1; fi
  local term=no; [ -t 1 ] && term=yes
  log "Progress shown with: $UI (window: $UI_SHOWN; terminal: $term; notifications: $NOTIFY)"
  if [ "$UI" = none ]; then echo "SpaceFleet: checking for updates..."; fi
}
notify() { [ "$NOTIFY" = 1 ] && { timeout 5 notify-send "$@" >/dev/null 2>&1 & } ; return 0; }
ui_text() {   # one line of status text
  log "ui: $1"
  case "$UI" in
    zenity|yad) printf '# %s\n' "$1" >&3 2>/dev/null ;;
    kdialog) qdbus $KREF setLabelText "$1" >/dev/null 2>&1 ;;
    *) echo "SpaceFleet: $1"
       case "$1" in Downloading*|"A new build"*) notify -a SpaceFleet "SpaceFleet" "$1" ;; esac ;;
  esac
}
ui_progress() {   # 0..100
  case "$UI" in
    zenity|yad) printf '%s\n' "$1" >&3 2>/dev/null ;;
    kdialog) qdbus $KREF Set "" value "$1" >/dev/null 2>&1 ;;
    *) if [ -t 1 ]; then printf '\r  %s%%   ' "$1"; fi ;;
  esac
}
ui_alive() {  # false only once a progress window that was shown has been closed by the player
  [ "$UI_SHOWN" = 1 ] || return 0
  case "$UI" in
    zenity|yad) kill -0 "$ZPID" 2>/dev/null ;;
    kdialog) qdbus $KREF value >/dev/null 2>&1 ;;
    *) return 0 ;;
  esac
}
ui_close() {
  case "$UI" in
    zenity|yad) exec 3>&- 2>/dev/null; [ -n "$ZPID" ] && kill "$ZPID" 2>/dev/null; rm -f "$UIFIFO" ;;
    kdialog) qdbus $KREF close >/dev/null 2>&1 ;;
    *) if [ -t 1 ]; then echo; fi ;;
  esac
}
ui_error() {  # a message the player must read (nothing to play)
  log "error: $1"
  case "$UI" in
    zenity|yad) ui_close; "$UI" --error --title="SpaceFleet" --text="$1" --width=420 >/dev/null 2>&1 ;;
    kdialog) ui_close; kdialog --title SpaceFleet --error "$1" >/dev/null 2>&1 ;;
    *) echo "SpaceFleet: $1" >&2; notify -u critical -a SpaceFleet "SpaceFleet" "$1" ;;
  esac
}
trap '' PIPE

# ---- helpers
reason_for() {   # curl exit code or "HTTP nnn" -> short human reason
  case "$1" in
    "HTTP 403"|"HTTP 429") echo "GitHub is limiting requests right now, try again later" ;;
    "HTTP 404") echo "no build has been published yet" ;;
    6|7|28|35|52|56|"HTTP 000") echo "no internet connection" ;;
    *) echo "download problem ($1)" ;;
  esac
}
# remote_id <headers file>: the identity of the file the server holds now, from the LAST response in a curl -D dump
# (after redirects): its ETag (GitHub's raw files carry one that changes with the content), else its size.
remote_id() {
  local e s
  e="$(tr -d '\r' < "$1" | awk 'tolower($0) ~ /^http\// { e = "" } tolower($1) == "etag:" { e = $2 } END { print e }' | tr -d '"')"
  if [ -n "$e" ]; then printf 'etag:%s' "$e"; return; fi
  s="$(tr -d '\r' < "$1" | awk 'tolower($0) ~ /^http\// { s = "" } tolower($1) == "content-length:" { s = $2 } END { print s }')"
  [ -n "$s" ] && printf 'size:%s' "$s"
}
header_size() { tr -d '\r' < "$1" | awk 'tolower($0) ~ /^http\// { s = "" } tolower($1) == "content-length:" { s = $2 } END { print s }'; }

cleanup_old() {   # cleanup_old <current tag> <previous tag>: keep those two, remove older builds unless one is still running
  local d n
  for d in "$VERS"/*/; do
    [ -d "$d" ] || continue
    n="$(basename "$d")"
    if [ "$n" = "$1" ] || [ "$n" = "$2" ]; then continue; fi
    if command -v pgrep >/dev/null 2>&1 && pgrep -f -- "${d%/}/$EXE" >/dev/null 2>&1; then
      log "Old build $n is in use; it will be cleaned up next time"; continue
    fi
    if safe_rm "${d%/}"; then log "Removed old build $n"; fi
  done
}

FAIL_REASON=""
fail() { FAIL_REASON="$1"; log "update failed: $1"; return 1; }

# update <installed tag or empty>: returns 0 (NEWTAG set), 1 (FAIL_REASON set) or 2 (the player closed the window)
# The build is the file SpaceFleet-linux.tar.gz on the public repo's main branch. A HEAD request gives its ETag; when
# that equals the one remembered in current-download.txt nothing is downloaded.
NEWTAG=""
update() {
  local installed="$1" url="$RAW/$ASSET" code rc rid have tag size got n pct part pkg curlpid ex d f
  mkdir -p "$DL"
  code="$(curl -sSIL --connect-timeout 15 --max-time 60 -A "$UA" -D "$DL/head.txt" -o /dev/null -w '%{http_code}' "$url" 2>>"$LOG")"; rc=$?
  if [ $rc -ne 0 ]; then fail "$(reason_for $rc)"; return 1; fi
  case "$code" in 2??) ;; *) fail "$(reason_for "HTTP $code")"; return 1 ;; esac
  ui_alive || return 2
  rid="$(remote_id "$DL/head.txt")"
  have="$(tr -d ' \r\n' 2>/dev/null < "$ROOT/current-download.txt")"
  log "Server: ${rid:-?}; installed: ${installed:-none} from ${have:-?}"
  if [ -n "$installed" ] && [ -n "$rid" ] && [ "$rid" = "$have" ]; then NEWTAG="$installed"; cleanup_old "$installed" "$(read_tag previous.txt)"; return 0; fi

  size="$(header_size "$DL/head.txt")"
  part="$DL/part"
  rm -f "$part"
  if [ -n "$installed" ]; then ui_text "A new build is available (you have $installed). Downloading..."; else ui_text "Downloading SpaceFleet..."; fi
  curl -sSL --connect-timeout 15 --speed-limit 1000 --speed-time 60 -A "$UA" -D "$DL/get.txt" -o "$part" "$url" 2>>"$LOG" &
  curlpid=$!
  while kill -0 "$curlpid" 2>/dev/null; do
    if ! ui_alive; then kill "$curlpid" 2>/dev/null; wait "$curlpid" 2>/dev/null; rm -f "$part"; return 2; fi
    got="$(stat -c %s "$part" 2>/dev/null || echo 0)"
    if [ -n "$size" ] && [ "$size" -gt 0 ] 2>/dev/null; then
      pct=$(( got * 100 / size )); [ "$pct" -gt 99 ] && pct=99; ui_progress "$pct"
    fi
    sleep 0.3
  done
  wait "$curlpid"; n=$?
  if [ $n -ne 0 ]; then rm -f "$part"; fail "$(reason_for $n)"; return 1; fi
  got="$(stat -c %s "$part" 2>/dev/null || echo 0)"
  size="$(header_size "$DL/get.txt")"; rid="$(remote_id "$DL/get.txt")"
  log "Downloaded $got bytes (server says ${size:-?}; ${rid:-?}; curl exit $n)"
  if [ ! -s "$part" ]; then rm -f "$part"; fail "the download did not arrive (0 bytes)"; return 1; fi
  if [ -n "$size" ] && [ "$got" != "$size" ]; then rm -f "$part"; fail "the download is incomplete ($got of $size bytes)"; return 1; fi

  ui_text "Unpacking..."
  ex="$DL/u"; rm -rf -- "$ex"; mkdir -p "$ex"
  if ! tar -xzf "$part" -C "$ex" 2>>"$LOG"; then fail "the download is damaged (it could not be unpacked)"; return 1; fi
  rm -f "$part"
  # The build's tag comes from inside the archive: current.txt next to versions/<tag>/SpaceFleet.Game.
  pkg=""; tag=""
  for d in "$ex" "$ex"/*/; do
    d="${d%/}"
    [ -f "$d/current.txt" ] || continue
    tag="$(tr -d ' \r\n' < "$d/current.txt")"
    if valid_tag "$tag" && [ -f "$d/versions/$tag/$EXE" ]; then pkg="$d"; break; fi
    tag=""
  done
  [ -n "$pkg" ] || { fail "the download does not contain the game"; return 1; }
  log "The download holds build $tag"

  if [ -n "$installed" ] && [ "$tag" = "$installed" ]; then
    log "Build $tag is already installed"
  else
    mkdir -p "$VERS"
    if [ -e "$VERS/$tag" ]; then safe_rm "$VERS/$tag" || { fail "build $tag is already there and in use"; return 1; }; fi
    mv "$pkg/versions/$tag" "$VERS/$tag" || { fail "could not install build $tag"; return 1; }
    chmod +x "$VERS/$tag/$EXE" 2>/dev/null
    [ -f "$VERS/$tag/$EXE" ] || { fail "the new build did not install"; return 1; }
    if [ -n "$installed" ]; then printf '%s' "$installed" > "$ROOT/previous.txt"; fi
    printf '%s' "$tag" > "$ROOT/current.txt.tmp" && mv -f "$ROOT/current.txt.tmp" "$ROOT/current.txt"
    log "Switched to build $tag"
  fi
  [ -n "$rid" ] && printf '%s' "$rid" > "$ROOT/current-download.txt"

  # self-update: stage the new script (syntax-checked, only when it differs); it runs from the next start.
  # Readme files are copied.
  # Installed mode (.deb): the script in /usr is never touched; the copy goes into the game folder and runs from the
  # next start on (it is not running now, so it is written directly).
  if [ "$INSTALLED_MODE" = 1 ]; then
    if [ -f "$pkg/play-spacefleet.sh" ] && bash -n "$pkg/play-spacefleet.sh" 2>/dev/null \
       && cp "$pkg/play-spacefleet.sh" "$ROOT/.play-spacefleet.sh.tmp" && mv -f "$ROOT/.play-spacefleet.sh.tmp" "$ROOT/play-spacefleet.sh"; then
      chmod +x "$ROOT/play-spacefleet.sh"; log "Installed the launcher of build $tag into the game folder (used from the next start)"
    fi
  elif [ -f "$pkg/play-spacefleet.sh" ] && bash -n "$pkg/play-spacefleet.sh" 2>/dev/null && ! cmp -s "$pkg/play-spacefleet.sh" "$SELF"; then
    if cp "$pkg/play-spacefleet.sh" "$SELF.new"; then
      chmod +x "$SELF.new"; log "Staged a new launcher script (active next start)"
    fi
  fi
  for f in README-FIRST.txt PLAYING.md; do
    if [ -f "$pkg/$f" ]; then cp "$pkg/$f" "$ROOT/$f" 2>/dev/null; fi
  done
  rm -rf -- "$ex"

  cleanup_old "$tag" "$installed"
  NEWTAG="$tag"
  return 0
}

# The game's .NET runtime uses the system's ICU library for text handling. Every Ubuntu desktop has it (libicu74 on
# 24.04, libicu70 on 22.04); where it is missing the game runs in .NET's invariant mode instead of failing.
check_icu() {
  if command -v ldconfig >/dev/null 2>&1 && ! ldconfig -p 2>/dev/null | grep -q 'libicuuc\.so'; then
    if ! ls /usr/lib/*/libicuuc.so.* /usr/lib/libicuuc.so.* /lib/*/libicuuc.so.* >/dev/null 2>&1; then
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
      log "libicu not found: starting with DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 (install it with: sudo apt install libicu-dev)"
    fi
  fi
}

# start_game <tag> [game arguments...]: 0 = the game is running (or ran and closed normally), 1 = it failed to start
START_ERR=""
start_game() {
  local tag="$1" dir="$VERS/$1" pid rc i glog="$LDIR/game-last.log"
  shift
  chmod +x "$dir/$EXE" 2>/dev/null
  # The game keeps settings and saves in ~/.config/SpaceFleet. .NET gives the game an empty path when ~/.config does
  # not exist yet (a fresh account or a container), and the saves would then land inside the build folder.
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}" 2>/dev/null
  check_icu
  cd "$dir" || { START_ERR="cannot open $dir"; return 1; }
  if command -v setsid >/dev/null 2>&1; then
    setsid nohup "./$EXE" "$@" > "$glog" 2>&1 < /dev/null 9>&- &
  else
    nohup "./$EXE" "$@" > "$glog" 2>&1 < /dev/null 9>&- &
  fi
  pid=$!
  log "Started SpaceFleet build $tag (process id $pid)${*:+ with: $*}"
  # A game that cannot start (a missing system library, no graphics driver) quits within a few seconds.
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do
    kill -0 "$pid" 2>/dev/null || break
    sleep 0.2
  done
  if ! kill -0 "$pid" 2>/dev/null; then
    wait "$pid"; rc=$?
    if [ "$rc" != 0 ]; then
      START_ERR="SpaceFleet build $tag closed right after starting (exit code $rc). Its output is in $glog; the last lines:
$(tail -n 6 "$glog" 2>/dev/null | cut -c1-200)"
      log "The game quit at once (exit code $rc)"
      return 1
    fi
  fi
  return 0
}

# ---- main
MISSING=""
for t in curl tar gzip; do command -v "$t" >/dev/null 2>&1 || MISSING="$MISSING $t"; done

INSTALLED="$(installed_tag)" || INSTALLED=""
if [ -n "${SPACEFLEET_NO_UPDATE:-}" ] && [ -n "$INSTALLED" ]; then
  log "SPACEFLEET_NO_UPDATE is set; starting build $INSTALLED without an update check"
  echo "SpaceFleet: starting build $INSTALLED (no update check)"
  if start_game "$INSTALLED" "$@"; then exit 0; fi
  echo "SpaceFleet: $START_ERR" >&2; exit 1
fi
if [ -n "$MISSING" ]; then
  if [ -n "$INSTALLED" ]; then
    log "Missing:$MISSING; starting without an update check"
    if start_game "$INSTALLED" "$@"; then exit 0; fi
    echo "SpaceFleet: $START_ERR" >&2; exit 1
  fi
  echo "SpaceFleet needs these programs to download the game and they are not installed:$MISSING
Install them with:   sudo apt install$MISSING
and run this again." >&2
  log "Missing:$MISSING; nothing installed"
  exit 1
fi
if [ -d "$DL" ]; then safe_rm "$DL"; fi
ui_open
update "$INSTALLED"; rc=$?
START=""
NOTE=""
case $rc in
  0) START="$NEWTAG" ;;
  2) log "Update stopped by the player (the progress window was closed)"; START="$(installed_tag)" || START=""
     [ -n "$START" ] || NOTE="The download was stopped when the progress window was closed, so SpaceFleet is not installed yet. Start it again to download it." ;;
  *) NOTE="Could not update ($FAIL_REASON)."; START="$(installed_tag)" || START="" ;;
esac
if [ -d "$DL" ] && [ "$UI" != zenity ] && [ "$UI" != yad ]; then safe_rm "$DL"; fi
if [ -n "$START" ]; then
  if [ -n "$NOTE" ]; then ui_text "$NOTE Starting build $START instead."; sleep 2.5
  elif [ "$START" != "$INSTALLED" ]; then ui_text "Updated to build $START. Starting SpaceFleet..."
  else ui_text "SpaceFleet is up to date (build $START). Starting..."; fi
  if start_game "$START" "$@"; then
    ui_close
    if [ -d "$DL" ]; then safe_rm "$DL"; fi
    exit 0
  fi
  ui_error "$START_ERR"
  if [ -d "$DL" ]; then safe_rm "$DL"; fi
  exit 1
fi
case $rc in
  2) ui_error "$NOTE" ;;
  *) ui_error "${NOTE:-Could not find an installed version.} SpaceFleet is not installed in $ROOT yet and could not be downloaded now. Check your internet connection and try again; details are in $LOG." ;;
esac
if [ -d "$DL" ]; then safe_rm "$DL"; fi
exit 1
