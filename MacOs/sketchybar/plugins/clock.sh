#!/bin/bash

# Label: date/time. Click toggles a popup of today's calendar events, read by
# the EventKit helper calendar/today_events (compiled on first use).

source "$CONFIG_DIR/colors.sh"

HELPER_DIR="$CONFIG_DIR/plugins/calendar"
HELPER="$HELPER_DIR/today_events"

build_popup() {
  sketchybar --remove '/clock\.event\..*/' 2>/dev/null

  if [ ! -x "$HELPER" ] || [ "$HELPER_DIR/today_events.swift" -nt "$HELPER" ]; then
    swiftc -O "$HELPER_DIR/today_events.swift" -o "$HELPER" 2>/dev/null
  fi

  local events status
  events="$("$HELPER")"
  status=$?

  if [ $status -eq 2 ]; then
    sketchybar --add item clock.event.0 popup.clock \
               --set clock.event.0 icon.drawing=off label="Grant Calendar access…" label.color="$ORANGE" \
                     click_script="open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars'; sketchybar --set clock popup.drawing=off"
    return
  fi

  if [ -z "$events" ]; then
    sketchybar --add item clock.event.0 popup.clock \
               --set clock.event.0 icon.drawing=off label="No events today" label.color="$COMMENT"
    return
  fi

  local i=0
  while IFS=$'\t' read -r time title; do
    sketchybar --add item "clock.event.$i" popup.clock \
               --set "clock.event.$i" icon="$time" icon.color="$BLUE" \
                     icon.font="Hack Nerd Font:Bold:13.0" icon.width=110 \
                     label="$title" label.font="Hack Nerd Font:Regular:13.0" \
                     click_script="open -a Calendar; sketchybar --set clock popup.drawing=off"
    i=$((i + 1))
  done <<< "$events"
}

case "$SENDER" in
  mouse.clicked)
    if [ "$(sketchybar --query clock | jq -r '.popup.drawing')" = "on" ]; then
      sketchybar --set clock popup.drawing=off
    else
      build_popup
      sketchybar --set clock popup.drawing=on
    fi
    ;;
  mouse.exited.global)
    sketchybar --set clock popup.drawing=off
    ;;
  *)
    sketchybar --set "$NAME" label="$(date '+%d/%m %H:%M')"
    ;;
esac
