#!/bin/bash

# Network pill: VPN (utun interface), connected (primary IPv4), or not
# connected. Appends Wi-Fi transmit rate when on Wi-Fi. macOS redacts the
# SSID for CLI tools, so it is omitted. system_profiler takes a few seconds;
# update_freq is set accordingly.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

NWI="$(scutil --nwi)"
IP_ADDRESS="$(echo "$NWI" | awk '/IPv4 network interface information/{f=1} f && /address/{print $3; exit}')"
IS_VPN="$(echo "$NWI" | grep -m1 'utun')"

IFACE="$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')"
RATE=""
if ipconfig getsummary "$IFACE" | grep -q 'LinkStatusActive : TRUE'; then
  RATE="$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Current Network Information:/{f=1} f && /Transmit Rate:/{print $3; exit}')"
fi

if [ -n "$IS_VPN" ]; then
  COLOR=$CYAN
  ICON=$ICON_VPN
  LABEL="VPN"
elif [ -n "$IP_ADDRESS" ]; then
  COLOR=$BLUE
  ICON=$ICON_WIFI
  LABEL="$IP_ADDRESS"
else
  COLOR=$COMMENT
  ICON=$ICON_WIFI_OFF
  LABEL="Not Connected"
fi

[ -n "$RATE" ] && [ -n "$IP_ADDRESS$IS_VPN" ] && LABEL="$LABEL · ${RATE}Mbps"

sketchybar --set "$NAME" background.color="$COLOR" icon="$ICON" label="$LABEL"
