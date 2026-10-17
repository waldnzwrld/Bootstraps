#!/bin/bash

# $1: workspace this item represents. FOCUSED_WORKSPACE is passed by the
# aerospace_workspace_change trigger; other senders query it.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

WORKSPACE="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

apps=$(aerospace list-windows --workspace "$WORKSPACE" --format '%{app-name}' | sort -u)

icons=""
while read -r app; do
  [ -n "$app" ] && icons+="$(get_app_icon "$app") "
done <<< "$apps"

if [ -z "$icons" ]; then
  label=(label.drawing=off)
else
  label=(label.drawing=on label="${icons% }")
fi

if [ "$WORKSPACE" != "$FOCUSED" ] && [ -z "$icons" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if [ "$WORKSPACE" = "$FOCUSED" ]; then
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

sketchybar --animate tanh 10 --set "$NAME" drawing=on "${label[@]}" "${state[@]}"
