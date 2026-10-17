#!/bin/sh

# front_app_switched passes the app name in INFO; on startup, query it.

APP="${INFO:-$(aerospace list-windows --focused --format '%{app-name}')}"

sketchybar --set "$NAME" label="$APP"
