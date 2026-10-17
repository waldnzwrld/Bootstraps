#!/bin/sh

# Click toggles `caffeinate -dimsu`. The PID file in $TMPDIR keeps the state
# across sketchybar reloads.

source "$CONFIG_DIR/colors.sh"

pid_file="${TMPDIR:-/tmp}/sketchybar-caffeinate.pid"

is_running() {
  [ -s "$pid_file" ] || return 1
  [ "$(ps -p "$(cat "$pid_file")" -o comm= 2>/dev/null)" = "/usr/bin/caffeinate" ]
}

if [ "$SENDER" = "mouse.clicked" ]; then
  if is_running; then
    kill "$(cat "$pid_file")"
    : > "$pid_file"
  else
    nohup /usr/bin/caffeinate -dimsu >/dev/null 2>&1 &
    printf '%s\n' "$!" > "$pid_file"
  fi
fi

if is_running; then
  sketchybar --set "$NAME" icon=󰒳 icon.color="$ORANGE"
else
  sketchybar --set "$NAME" icon=󰒲 icon.color="$COMMENT"
fi
