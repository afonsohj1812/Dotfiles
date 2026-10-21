#!/bin/bash
chrome="google-chrome-stable --disable-features=WaylandWpColorManagerV1 --new-window"

hyprctl dispatch workspace 1
$chrome >/dev/null 2>&1 &
sleep 1

hyprctl dispatch workspace 2
code >/dev/null 2>&1 &
sleep 1

hyprctl dispatch workspace 3
$chrome https://tasks.eyecon-group.com/ https://chat.google.com/u/1/app/home >/dev/null 2>&1 &
sleep 1
big=$(hyprctl activewindow -j | jq -r .address)

$chrome https://www.instagram.com/direct/t/109241313802116/ >/dev/null 2>&1 &
sleep 1
[ -n "$big" ] && hyprctl dispatch focuswindow "address:$big" && hyprctl dispatch resizeactive exact 75% 100%

hyprctl dispatch workspace 2
