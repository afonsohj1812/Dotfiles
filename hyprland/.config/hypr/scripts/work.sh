#!/bin/bash
chrome="google-chrome-stable --disable-features=WaylandWpColorManagerV1 --new-window"

hyprctl dispatch 'hl.dsp.focus({ workspace = 1 })'
$chrome >/dev/null 2>&1 &
sleep 2

hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'
code >/dev/null 2>&1 &
sleep 2

hyprctl dispatch 'hl.dsp.focus({ workspace = 3 })'
$chrome https://tasks.eyecon-group.com/ https://chat.google.com/u/1/app/home >/dev/null 2>&1 &
sleep 2
big=$(hyprctl activewindow -j | jq -r .address)

$chrome https://www.instagram.com/direct/t/109241313802116/ >/dev/null 2>&1 &
sleep 2
[ -n "$big" ] && hyprctl eval "local m = hl.get_window('address:$big').monitor hl.dispatch(hl.dsp.focus({ window = 'address:$big' })) hl.dispatch(hl.dsp.window.resize({ x = m.width * 0.75, y = m.height }))"

hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'
