#!/usr/bin/env bash
# Flip kanata's base layer based on the focused X11 window (Cinnamon/X11).
#   terminal apps -> "term"  (native Super/Ctrl)
#   everything else -> "gui" (Cmd -> Ctrl)
# Requires: bash, xprop, and kanata started with --port.
# X11 twin of sway-app-watch.sh (no swaymsg/jq; event-driven via `xprop -spy`).

set -uo pipefail

PORT=5829
# Pipe-separated WM_CLASS regex for apps that should keep native Ctrl.
TERM_RE='^(com\.mitchellh\.ghostty|Alacritty|kitty|foot|org\.wezfurlong\.wezterm)$'

send() {
  # Open one TCP connection to kanata and send a single ChangeLayer message.
  exec 3<>"/dev/tcp/127.0.0.1/$PORT" 2>/dev/null || return 1
  printf '{"ChangeLayer":{"new":"%s"}}\n' "$1" >&3
  exec 3>&- 3<&- 2>/dev/null || true
}

layer_for() { [[ "$1" =~ $TERM_RE ]] && echo term || echo gui; }

# WM_CLASS ("class" field, i.e. the last quoted string) of the active window.
active_class() {
  local id cls
  id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | grep -o '0x[0-9a-fA-F]\+' | head -n1)
  [[ -n "$id" && "$id" != 0x0 ]] || { echo ""; return; }
  cls=$(xprop -id "$id" WM_CLASS 2>/dev/null)
  echo "$cls" | sed -n 's/.*"\([^"]*\)"$/\1/p'
}

# Wait (up to ~10s) for kanata's TCP server to come up.
for _ in $(seq 1 50); do
  if exec 3<>"/dev/tcp/127.0.0.1/$PORT" 2>/dev/null; then
    exec 3>&- 3<&- 2>/dev/null
    break
  fi
  sleep 0.2
done

# Set the initial layer from whatever is focused right now.
send "$(layer_for "$(active_class)")" || true

# React to active-window changes forever (xprop -spy emits a line per change).
xprop -spy -root _NET_ACTIVE_WINDOW 2>/dev/null \
  | while IFS= read -r _; do
      send "$(layer_for "$(active_class)")" || true
    done
