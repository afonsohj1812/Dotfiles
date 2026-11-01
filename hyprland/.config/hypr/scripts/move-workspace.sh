#!/bin/bash
from=$(hyprctl activeworkspace -j | jq .id)
hyprctl --batch "$(hyprctl clients -j | jq -r --argjson a "$from" --argjson b "$1" \
    '.[] | select(.workspace.id == $a or .workspace.id == $b)
    | "dispatch hl.dsp.window.move({ workspace = \(if .workspace.id == $a then $b else $a end), follow = false, window = \"address:\(.address)\" });"') dispatch hl.dsp.focus({ workspace = $1 })"
