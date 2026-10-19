#!/bin/bash

# Network pill: VPN (utun interface), Wi-Fi signal strength icon, or not
# connected. The IP, signal quality, and transmit rate show only on hover.
# macOS redacts the SSID for CLI tools, so it is omitted. system_profiler takes
# a few seconds, so periodic runs cache the labels and hover events only read
# the cache.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

cache="${TMPDIR:-/tmp}/sketchybar-wifi.labels"

show_label() {
  if [ -n "$1" ]; then
    sketchybar --set "$NAME" label="$1" label.drawing=on icon.padding_right=0
  else
    sketchybar --set "$NAME" label.drawing=off icon.padding_right=8
  fi
}

# Cache line 1: idle label (empty hides it); line 2: hover label.
if [ "$SENDER" = "mouse.entered" ] || [ "$SENDER" = "mouse.exited" ]; then
  { IFS= read -r IDLE; IFS= read -r HOVER; } < "$cache" 2>/dev/null
  if [ "$SENDER" = "mouse.entered" ]; then show_label "$HOVER"; else show_label "$IDLE"; fi
  exit 0
fi

NWI="$(scutil --nwi)"
IP_ADDRESS="$(echo "$NWI" | awk '/IPv4 network interface information/{f=1} f && /address/{print $3; exit}')"
IS_VPN="$(echo "$NWI" | grep -m1 'utun')"

IFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"
RSSI=""
RATE=""
if ipconfig getsummary "$IFACE" | grep -q 'LinkStatusActive : TRUE'; then
  read -r RSSI RATE <<< "$(system_profiler SPAirPortDataType 2>/dev/null | awk '
    /Current Network Information:/{f=1} /Other Local Wi-Fi Networks:/{f=0}
    f && /Signal \/ Noise:/{rssi=$4} f && /Transmit Rate:/{rate=$3}
    END{print rssi, rate}')"
fi

# Signal quality: -100 dBm -> 0%, -50 dBm or better -> 100%.
QUALITY=""
if [ -n "$RSSI" ]; then
  QUALITY=$(( 2 * (RSSI + 100) ))
  (( QUALITY > 100 )) && QUALITY=100
  (( QUALITY < 0 )) && QUALITY=0
fi

if [ -n "$IS_VPN" ]; then
  COLOR=$CYAN
  ICON=$ICON_VPN
  IDLE="VPN"
elif [ -n "$IP_ADDRESS" ]; then
  COLOR=$BLUE
  IDLE=""
  if [ -z "$QUALITY" ]; then
    ICON=$ICON_WIFI
  elif (( QUALITY > 85 )); then
    ICON=${ICONS_WIFI_SIGNAL[3]}
  elif (( QUALITY >= 50 )); then
    ICON=${ICONS_WIFI_SIGNAL[2]}
  elif (( QUALITY > 35 )); then
    ICON=${ICONS_WIFI_SIGNAL[1]}
  else
    ICON=${ICONS_WIFI_SIGNAL[0]}
  fi
else
  COLOR=$COMMENT
  ICON=$ICON_WIFI_OFF
  IDLE="Not Connected"
fi

HOVER="${IP_ADDRESS:-$IDLE}"
[ -n "$QUALITY" ] && HOVER="$HOVER · ${QUALITY}%"
[ -n "$RATE" ] && HOVER="$HOVER · ${RATE}Mbps"

printf '%s\n%s\n' "$IDLE" "$HOVER" > "$cache"

sketchybar --set "$NAME" background.color="$COLOR" icon="$ICON"
show_label "$IDLE"
