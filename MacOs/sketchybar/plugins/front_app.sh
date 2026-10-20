#!/bin/sh

# Label is the window title when the focused app is the only app in the
# workspace, otherwise the app name.

WINDOW="$(aerospace list-windows --focused --format '%{app-name}|%{window-title}' 2>/dev/null)"
APP="${WINDOW%%|*}"
TITLE="${WINDOW#*|}"
APP="${APP:-$INFO}"

APPS="$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null | sort -u | wc -l | tr -d ' ')"

if [ "$APPS" = 1 ] && [ -n "$TITLE" ] && [ "$TITLE" != "$WINDOW" ]; then
  LABEL="$TITLE"
else
  LABEL="$APP"
fi

sketchybar --set "$NAME" label="$LABEL"
