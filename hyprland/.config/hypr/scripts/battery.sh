#!/bin/bash

battery=/sys/class/power_supply/BAT1/status

notify() {
    notify-send -a Power -i "$3" "$1" "$2"
}

last_rate=""
set_refresh() {
    [ "$1" = "Discharging" ] && rate=72 || rate=144
    [ "$rate" = "$last_rate" ] && return
    last_rate=$rate
    hyprctl keyword monitor "eDP-1,1920x1080@${rate},auto,1"
}

prev=$(cat "$battery" 2>/dev/null)
set_refresh "$prev"
while true; do
    cur=$(cat "$battery" 2>/dev/null)
    if [ -n "$cur" ] && [ "$cur" != "$prev" ]; then
        case "$cur" in
            Charging)       notify "Charging" "Power connected." "battery-charging" ;;
            Discharging)    notify "On battery" "Power disconnected." "battery" ;;
            Full)           notify "Fully charged" "Battery at 100%." "battery-full" ;;
        esac
        set_refresh "$cur"
        prev="$cur"
    fi
    sleep 1
done
