#!/bin/bash

# Icon/label track output volume; click toggles a popup slider (volume.slider)
# whose own click sets the volume.

update() {
  local volume="$1"

  case "$volume" in
    [6-9][0-9]|100) ICON="󰕾"
    ;;
    [3-5][0-9]) ICON="󰖀"
    ;;
    [1-9]|[1-2][0-9]) ICON="󰕿"
    ;;
    *) ICON="󰖁"
  esac

  sketchybar --set volume icon="$ICON" label="$volume%" \
             --set volume.slider slider.percentage="$volume"
}

case "$SENDER" in
  volume_change)
    update "$INFO"
    ;;
  mouse.clicked)
    sketchybar --set volume popup.drawing=toggle
    ;;
  mouse.exited.global)
    sketchybar --set volume popup.drawing=off
    ;;
  *)
    update "$(osascript -e 'output volume of (get volume settings)')"
    ;;
esac
