#!/bin/bash

# Updates every space.<sid> item. A workspace is shown if it has windows or is
# focused; each monitor's shown list is then windowed to MAX_SHOWN slots:
#   focused <= 4:        1 2 3 4 … n-1 n
#   5 <= focused <= n-3: 1 2 3 … f … n
#   focused >= n-2:      1 2 3 … n-2 n-1 n
# space_gap.<monitor>.<1|2> are moved into elided runs.
# FOCUSED_WORKSPACE is passed by the aerospace_workspace_change trigger;
# other senders query it.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

MAX_SHOWN=7
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
BAR_ITEMS=$(sketchybar --query bar)

# $1: 1-based position in the shown list; uses n and focused_pos.
in_window() {
  local i=$1
  (( n <= MAX_SHOWN || i <= 3 || i == n )) && return 0
  if (( focused_pos <= 4 )); then
    (( i == 4 || i == n - 1 ))
  elif (( focused_pos >= n - 2 )); then
    (( i >= n - 2 ))
  else
    (( i == focused_pos ))
  fi
}

args=()

for monitor in $(aerospace list-monitors --format '%{monitor-id}'); do
  shown=()
  focused_pos=0

  for sid in $(aerospace list-workspaces --monitor "$monitor"); do
    [[ $BAR_ITEMS == *"\"space.$sid\""* ]] || continue

    icons=""
    while read -r app; do
      [ -n "$app" ] && icons+="$(get_app_icon "$app") "
    done <<< "$(aerospace list-windows --workspace "$sid" --format '%{app-name}' | sort -u)"

    if [ "$sid" != "$FOCUSED" ] && [ -z "$icons" ]; then
      args+=(--set "space.$sid" drawing=off)
      continue
    fi

    if [ -z "$icons" ]; then
      label=(label.drawing=off)
    else
      label=(label.drawing=on label="${icons% }")
    fi

    if [ "$sid" = "$FOCUSED" ]; then
      focused_pos=$(( ${#shown[@]} + 1 ))
      state=(
        icon.highlight=on
        label.highlight=on
        background.color=$BG_ACTIVE
        background.border_color=$BLUE
        background.border_width=2
      )
    else
      state=(
        icon.highlight=off
        label.highlight=off
        background.color=$BG_INACTIVE
        background.border_color=$COMMENT
        background.border_width=1
      )
    fi

    args+=(--set "space.$sid" "${label[@]}" "${state[@]}")
    shown+=("$sid")
  done

  n=${#shown[@]}
  gap=0
  prev=""
  for (( i = 1; i <= n; i++ )); do
    item="space.${shown[i-1]}"
    if in_window "$i"; then
      args+=(--set "$item" drawing=on)
      prev="$item"
    else
      args+=(--set "$item" drawing=off)
      if [ -n "$prev" ]; then
        gap=$(( gap + 1 ))
        args+=(--move "space_gap.$monitor.$gap" after "$prev"
               --set "space_gap.$monitor.$gap" drawing=on)
        prev=""
      fi
    fi
  done
  for (( g = gap + 1; g <= 2; g++ )); do
    args+=(--set "space_gap.$monitor.$g" drawing=off)
  done
done

sketchybar --animate tanh 10 "${args[@]}"
