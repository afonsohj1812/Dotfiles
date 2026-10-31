#!/bin/bash

metric="$1"
pct=0

case "$metric" in
    cpu)
        icon=$(printf '\U000f035b')
        sf="${XDG_RUNTIME_DIR:-/tmp}/waybar-ring-cpu"
        read -r _ u n s i io ir so st _ < /proc/stat
        total=$((u + n + s + i + io + ir + so + st)); idle=$((i + io))
        pt=0; pi=0; ppct=0
        [[ -f $sf ]] && read -r pt pi ppct < "$sf"
        dt=$((total - pt)); di=$((idle - pi))
        if (( pt == 0 )); then
            pct=0
            echo "$total $idle $pct" > "$sf"
        elif (( dt >= 50 )); then
            pct=$(( 100 * (dt - di) / dt ))
            echo "$total $idle $pct" > "$sf"
        else
            pct=$ppct
        fi
        tip="CPU ${pct}%"
        ;;
    memory)
        icon=$(printf '\U0000f0c9')
        pct=$(free | awk '/^Mem:/{printf "%d", $3 / $2 * 100}')
        tip="RAM ${pct}%"
        ;;
    disk)
        icon=$(printf '\U0000e6ad')
        pct=$(df --output=pcent / | tail -1 | tr -dc '0-9')
        tip="Disk ${pct}%"
        ;;
    temp)
        icon=$(printf '\U0000f2c9')
        t=0
        for z in /sys/class/thermal/thermal_zone*/temp; do
            [[ -r $z ]] || continue
            v=$(< "$z"); (( v > t )) && t=$v
        done
        pct=$(( t / 1000 ))
        level_val=$(( (pct - 30) * 100 / 60 ))
        tip="Temp ${pct}°C"
        ;;
    *)
        exit 1
        ;;
esac

level_val=${level_val:-$pct}
(( level_val < 0 )) && level_val=0
(( level_val > 100 )) && level_val=100
level=$(( level_val * 20 / 100 ))

[[ $metric == disk ]] && crit=80 || crit=90
classes="\"ring\", \"ring-${level}\""
(( pct >= crit )) && classes+=', "critical"'

printf '{"text": "%s", "class": [%s], "percentage": %d, "tooltip": "%s"}\n' \
    "$icon" "$classes" "$pct" "$tip"
