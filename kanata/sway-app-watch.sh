#!/usr/bin/env bash
# Flip kanata's base layer based on the focused Sway window.
#   terminal apps -> "term"  (native Super/Ctrl)
#   everything else -> "gui" (Cmd -> Ctrl)
# Requires: bash, jq, swaymsg, and kanata started with --port.
#
# Supervised by the systemd user service kanata-watch.service (Restart=always),
# which is started from the sway config AFTER WAYLAND_DISPLAY/SWAYSOCK are
# imported into the systemd --user environment. The outer `while true` loop
# below ALSO self-heals if `swaymsg -t subscribe` ever exits (an IPC hiccup or
# a sway reload), so a dropped subscription re-establishes in ~1s instead of
# silently stranding kanata in the wrong layer (which turns homerow-Ctrl into
# Super+hjkl = sway window focus).

set -uo pipefail

PORT=5829
# Pipe-separated app_id / X class regex for apps that should keep native Ctrl.
TERM_RE='^(com\.mitchellh\.ghostty|Alacritty|kitty|foot|org\.wezfurlong\.wezterm)$'

send() {
  # Open one TCP connection to kanata and send a single ChangeLayer message.
  exec 3<>"/dev/tcp/127.0.0.1/$PORT" 2>/dev/null || return 1
  printf '{"ChangeLayer":{"new":"%s"}}\n' "$1" >&3
  exec 3>&- 3<&- 2>/dev/null || true
}

layer_for() { [[ "$1" =~ $TERM_RE ]] && echo term || echo gui; }

# Wait (up to ~10s) for kanata's TCP server to come up on this connection.
wait_for_kanata() {
  for _ in $(seq 1 50); do
    if exec 3<>"/dev/tcp/127.0.0.1/$PORT" 2>/dev/null; then
      exec 3>&- 3<&- 2>/dev/null
      return 0
    fi
    sleep 0.2
  done
  return 1
}

# Reconnect loop: survives kanata restarts and dropped sway subscriptions.
while true; do
  wait_for_kanata || { sleep 1; continue; }

  # Set the initial layer from whatever is focused right now.
  cur=$(swaymsg -t get_tree 2>/dev/null \
    | jq -r '.. | objects | select(.focused==true) | (.app_id // .window_properties.class // "")' \
    | head -n1)
  send "$(layer_for "$cur")" || true

  # React to focus changes until the subscription ends, then loop to reconnect.
  swaymsg -t subscribe '["window"]' 2>/dev/null \
    | jq --unbuffered -r 'select(.change=="focus") | (.container.app_id // .container.window_properties.class // "")' \
    | while IFS= read -r app; do
        send "$(layer_for "$app")" || true
      done

  sleep 1
done
