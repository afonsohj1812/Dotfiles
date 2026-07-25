#!/bin/bash

PLAYER="spotify"
MAX_LEN=16
SPEED=1

offset=0
while true; do
    STATUS=$(playerctl --player=$PLAYER status 2>/dev/null)

    # Nothing running -> hide module
    if [ -z "$STATUS" ]; then
        echo ""
        offset=0
        sleep 1
        continue
    fi

    INFO=$(playerctl --player=$PLAYER metadata --format '{{artist}} - {{title}}' 2>/dev/null)

    # 4-cell bar: [□□□□] .. [■■■■], filled = round(vol/25)
    VOLUME=$(playerctl --player=$PLAYER volume 2>/dev/null | awk 'NF{
        n = int($1*100/25 + 0.5);
        s = "[";
        for (i = 1; i <= 4; i++) s = s (i <= n ? "■" : "□");
        printf "%s]", s
    }')

    if [ "$STATUS" = "Playing" ]; then
        # Marquee carousel
        TEXT="$INFO     "
        TLEN=${#TEXT}
        DISPLAY_TEXT="${TEXT:$offset:$MAX_LEN}"
        if [ ${#DISPLAY_TEXT} -lt $MAX_LEN ]; then
            REMAINING=$((MAX_LEN - ${#DISPLAY_TEXT}))
            DISPLAY_TEXT="${DISPLAY_TEXT}${TEXT:0:$REMAINING}"
        fi
        offset=$(((offset + SPEED) % TLEN))
    else
        DISPLAY_TEXT="${INFO:0:$MAX_LEN}"
        offset=0
    fi

    # pango-escape the visible window (titles may contain & < >)
    DISPLAY_TEXT=${DISPLAY_TEXT//&/&amp;}
    DISPLAY_TEXT=${DISPLAY_TEXT//</&lt;}
    DISPLAY_TEXT=${DISPLAY_TEXT//>/&gt;}
    echo "$VOLUME $DISPLAY_TEXT"
    sleep 0.25
done
