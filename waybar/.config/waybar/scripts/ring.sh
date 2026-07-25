#!/bin/bash
# Emits waybar custom-module JSON for a system metric: the icon as the (centered)
# text, and the fill level encoded as a CSS class (ring-0 .. ring-20) so the
# stylesheet can pick the matching ring SVG background. $1 = cpu|memory|disk|temp

metric="$1"
pct=0          # value used for warning/critical states (real % or real °C)
level_val=0    # 0..100 used to choose the ring SVG
icon=""
tip=""

case "$metric" in
    cpu)
        icon=$(printf '\U000f035b')
        sf=/tmp/waybar-ring-cpu
        read -r _ u n s i io ir so _ < /proc/stat
        total=$((u + n + s + i + io + ir + so)); idle=$((i + io))
        if [[ -f $sf ]]; then read -r pt pi < "$sf"; else pt=0; pi=0; fi
        echo "$total $idle" > "$sf"
        dt=$((total - pt)); di=$((idle - pi))
        (( dt > 0 )) && pct=$(( 100 * (dt - di) / dt )) || pct=0
        level_val=$pct
        tip="CPU ${pct}%"
        ;;
    memory)
        icon=$(printf '\U0000f0c9')
        pct=$(free | awk '/^Mem:/{printf "%d", $3 / $2 * 100}')
        level_val=$pct
        tip="RAM ${pct}%"
        ;;
    disk)
        icon=$(printf '\U0000e6ad')
        pct=$(df --output=pcent / | tail -1 | tr -dc '0-9')
        level_val=$pct
        tip="Disk ${pct}%"
        ;;
    temp)
        icon=$(printf '\U0000f2c9')
        t=0
        for z in /sys/class/thermal/thermal_zone*/temp; do
            [[ -r $z ]] || continue
            v=$(< "$z"); (( v > t )) && t=$v
        done
        pct=$(( t / 1000 ))                 # real °C, used for states
        level_val=$(( (pct - 30) * 100 / 60 ))  # map 30..90 °C -> 0..100
        tip="Temp ${pct}°C"
        ;;
    *)
        exit 1
        ;;
esac

(( level_val < 0 )) && level_val=0
(( level_val > 100 )) && level_val=100
level=$(( level_val * 20 / 100 ))
(( level > 20 )) && level=20

# Emit the critical class ourselves ($pct is real % for cpu/mem/disk,
# real °C for temp) so coloring doesn't depend on waybar's custom-module states.
case "$metric" in
    cpu|memory) crit=90 ;;
    disk)       crit=80 ;;
    temp)       crit=90 ;;
esac
state=""
(( pct >= crit )) && state="critical"

classes="\"ring\", \"ring-${level}\""
[ -n "$state" ] && classes="${classes}, \"${state}\""

printf '{"text": "%s", "class": [%s], "percentage": %d, "tooltip": "%s"}\n' \
    "$icon" "$classes" "$pct" "$tip"
