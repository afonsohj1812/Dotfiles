#!/bin/bash
# Swap every window between the current workspace and workspace $1, then follow.
from=$(hyprctl activeworkspace -j | jq .id)
hyprctl --batch "$(hyprctl clients -j | jq -r --argjson a "$from" --argjson b "$1" \
    '.[] | select(.workspace.id == $a or .workspace.id == $b)
    | "dispatch movetoworkspacesilent \(if .workspace.id == $a then $b else $a end),address:\(.address);"') dispatch workspace $1"
