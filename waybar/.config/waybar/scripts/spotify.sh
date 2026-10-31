#!/bin/bash

MAX_LEN=16

coproc P { exec playerctl --player=spotify --follow metadata --format $'{{status}}\t{{volume}}\t{{artist}} - {{title}}' 2>/dev/null; }
trap 'kill $P_PID 2>/dev/null' EXIT
trap exit TERM INT

STATUS=""
offset=0
while true; do
    if [ "$STATUS" = "Playing" ]; then timeout=(-t 0.25); else timeout=(); fi
    if read -r "${timeout[@]}" line <&"${P[0]}"; then
        IFS=$'\t' read -r STATUS vol INFO <<< "$line"
        offset=0
        VOLUME=$(awk -v v="$vol" 'BEGIN{
            n = int(v*100/25 + 0.5);
            s = "[";
            for (i = 1; i <= 4; i++) s = s (i <= n ? "■" : "□");
            printf "%s]", s
        }')
    elif (( $? <= 128 )); then
        exit 1
    fi

    if [ -z "$STATUS" ]; then
        echo ""
        continue
    fi

    if [ "$STATUS" = "Playing" ]; then
        TEXT="$INFO     "
        TLEN=${#TEXT}
        DISPLAY_TEXT="${TEXT:$offset:$MAX_LEN}"
        if [ ${#DISPLAY_TEXT} -lt $MAX_LEN ]; then
            REMAINING=$((MAX_LEN - ${#DISPLAY_TEXT}))
            DISPLAY_TEXT="${DISPLAY_TEXT}${TEXT:0:$REMAINING}"
        fi
        offset=$(((offset + 1) % TLEN))
    else
        DISPLAY_TEXT="${INFO:0:$MAX_LEN}"
    fi

    DISPLAY_TEXT=${DISPLAY_TEXT//&/&amp;}
    DISPLAY_TEXT=${DISPLAY_TEXT//</&lt;}
    DISPLAY_TEXT=${DISPLAY_TEXT//>/&gt;}
    echo "$VOLUME $DISPLAY_TEXT"
done
