#!/usr/bin/env sh

ICON_CMD=󰘳
ICON_COG=󰒓 # system settings, system information, tinkertool
ICON_CHART=󱕍 # activity monitor, btop
ICON_LOCK=󰌾

ICONS_SPACE=(󰎤 󰎧 󰎪 󰎭 󰎱 󰎳 󰎶)

ICON_APP=󰣆 # fallback app
ICON_TERM=󰆍 # fallback terminal app, terminal, warp, iterm2
ICON_PACKAGE=󰏓 # brew
ICON_DEV=󰅨 # nvim, xcode, vscode
ICON_FILE=󰉋 # ranger, finder
ICON_GIT=󰊢 # lazygit
ICON_LIST=󱃔 # taskwarrior, taskwarrior-tui, reminders, onenote
ICON_SCREENSAVOR=󱄄 # unimatrix, pipe.sh

ICON_WEATHER=󰖕 # weather
ICON_MAIL=󰇮 # mail, outlook
ICON_CALC=󰪚 # calculator, numi
ICON_MAP=󰆋 # maps, find my
ICON_MICROPHONE=󰍬 # voice memos
ICON_CHAT=󰍩 # messages, slack, teams, discord, telegram
ICON_VIDEOCHAT=󰍫 # facetime, zoom, webex
ICON_NOTE=󱞎 # notes, textedit, stickies, word, bat
ICON_CAMERA=󰄀 # photo booth
ICON_WEB=󰇧 # safari, beam, duckduckgo, arc, edge, chrome, firefox
ICON_HOMEAUTOMATION=󱉑 # home
ICON_MUSIC=󰎄 # music, spotify
ICON_PODCAST=󰦔 # podcasts
ICON_PLAY=󱉺 # tv, quicktime, vlc
ICON_BOOK=󰂿 # books
ICON_BOOKINFO=󱁯 # font book, dictionary
ICON_PREVIEW=󰋲 # screenshot, preview
ICON_PASSKEY=󰷡 # 1password
ICON_DOWNLOAD=󱑢 # progressive downloader, transmission
ICON_CAST=󱒃 # airflow
ICON_TABLE=󰓫 # excel
ICON_PRESENT=󰈩 # powerpoint
ICON_CLOUD=󰅧 # onedrive
ICON_PEN=󰏬 # curve
ICON_REMOTEDESKTOP=󰢹 # vmware, utm

ICON_CLOCK=󰥔 # clock, timewarrior, tty-clock
ICON_CALENDAR=󰃭 # calendar

ICON_WIFI=󰖩
ICON_WIFI_OFF=󰖪
ICON_VPN=󰦝 # vpn, nordvpn

ICONS_VOLUME=(󰸈 󰕿 󰖀 󰕾)

ICONS_BATTERY=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
ICONS_BATTERY_CHARGING=(󰢟 󰢜 󰂆 󰂇 󰂈 󰢝 󰂉 󰢞 󰂊 󰂋 󰂅)

ICON_SWAP=󰁯
ICON_RAM=󰓅
ICON_DISK=󰋊 # disk utility
ICON_CPU=󰘚

get_app_icon() {
  local app="$1"
  case "$app" in
    "Arc" | "Vivaldi" | "Safari" | "Google Chrome" | "Firefox" | "Brave Browser") echo "$ICON_WEB" ;;
    "Code" | "Visual Studio Code" | "VSCodium" | "Xcode" | "Zed") echo "$ICON_DEV" ;;
    "Ghostty" | "iTerm2" | "Terminal" | "Warp" | "Alacritty") echo "$ICON_TERM" ;;
    "Finder" | "访达") echo "$ICON_FILE" ;;
    "Discord" | "Slack" | "Telegram" | "Messages") echo "$ICON_CHAT" ;;
    "Spotify" | "Music" | "音乐") echo "$ICON_MUSIC" ;;
    "Notes" | "备忘录" | "TextEdit" | "Stickies" | "Microsoft Word") echo "$ICON_NOTE" ;;
    "System Settings" | "设置" | "System Information") echo "$ICON_COG" ;;
    "Activity Monitor" | "活动监视器") echo "$ICON_CHART" ;;
    "Mail" | "邮件" | "Microsoft Outlook") echo "$ICON_MAIL" ;;
    "Calendar" | "日历") echo "$ICON_CALENDAR" ;;
    "1Password") echo "$ICON_PASSKEY" ;;
    *) echo "$ICON_APP" ;; # Fallback
  esac
}
