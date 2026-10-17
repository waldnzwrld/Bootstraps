#!/usr/bin/env bash

# SketchyBar app menu: popup of the frontmost app's menu bar.
# Menus are read and pressed by menu_helper (Accessibility API, compiled from
# menu_helper.swift on first use); each level renders in one sketchybar call.
#
#   app_menu.sh [toggle]      open (top level) / close the popup
#   app_menu.sh list [path]   render the menu at path ("" = menu bar)
#   app_menu.sh press <path>  press the item at path and close the popup

source "$CONFIG_DIR/colors.sh"

DIR="$CONFIG_DIR/plugins/sketchymenu"
HELPER="$DIR/menu_helper"
SELF="$DIR/app_menu.sh"

CMD="${1:-toggle}"
MENU_PATH="${2:-}"

ensure_helper() {
  if [ ! -x "$HELPER" ] || [ "$DIR/menu_helper.swift" -nt "$HELPER" ]; then
    swiftc -O "$DIR/menu_helper.swift" -o "$HELPER" 2>/dev/null
  fi
}

ARGS=()
COUNT=0
add_row() {
  ARGS+=(--add item "menu.item.$COUNT" popup.menu --set "menu.item.$COUNT" icon.drawing=off "$@")
  COUNT=$((COUNT + 1))
}

render() {
  local path="$1" listing status
  listing="$("$HELPER" list "$path")"
  status=$?

  if [ $status -eq 2 ]; then
    add_row label="Grant Accessibility…" label.color="$ORANGE" \
      click_script="open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'; sketchybar --set menu popup.drawing=off"
  else
    if [ -n "$path" ]; then
      local parent="${path%/*}"
      [ "$parent" = "$path" ] && parent=""
      add_row label="‹ Back" click_script="$SELF list '$parent'"
      add_row label="────────"
    fi

    local idx enabled has_sub title prefix="${path:+$path/}"
    while IFS=$'\t' read -r idx enabled has_sub title; do
      [ -z "$idx" ] && continue
      if [ -z "$title" ]; then
        [ -n "$path" ] && add_row label="────────"
      elif [ "$has_sub" = "1" ]; then
        add_row label="$title ▸" click_script="$SELF list '$prefix$idx'"
      elif [ "$enabled" = "0" ]; then
        add_row label="$title" label.color="$COMMENT"
      elif [ -n "$path" ]; then
        add_row label="$title" click_script="$SELF press '$prefix$idx'"
      else
        add_row label="$title"
      fi
    done <<< "$listing"
  fi

  sketchybar --remove '/menu\.item\..*/' >/dev/null 2>&1
  sketchybar "${ARGS[@]}" --set menu popup.drawing=on
}

case "$CMD" in
  toggle)
    if [ "$(sketchybar --query menu | jq -r '.popup.drawing')" = "on" ]; then
      sketchybar --set menu popup.drawing=off --remove '/menu\.item\..*/' >/dev/null 2>&1
    else
      ensure_helper
      render ""
    fi
    ;;
  list)
    render "$MENU_PATH"
    ;;
  press)
    sketchybar --set menu popup.drawing=off --remove '/menu\.item\..*/' >/dev/null 2>&1
    "$HELPER" press "$MENU_PATH"
    ;;
esac
