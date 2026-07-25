#!/bin/bash

case "$(timedatectl show -p Timezone --value 2>/dev/null)" in
    *Azores*) LAT="38.6556"; LON="-27.2208" ;;  # Terceira (Azores)
    *)        LAT="40.2056"; LON="-8.4196"  ;;  # Coimbra (Europe/Lisbon)
esac

J=$(curl -s --max-time 8 \
    "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m&daily=temperature_2m_max,temperature_2m_min&timezone=auto" \
    2>/dev/null)

T=$(echo "$J"  | jq -r '.current.temperature_2m     | round' 2>/dev/null)
MX=$(echo "$J" | jq -r '.daily.temperature_2m_max[0] | round' 2>/dev/null)
MN=$(echo "$J" | jq -r '.daily.temperature_2m_min[0] | round' 2>/dev/null)

if [ -z "$T" ] || [ "$T" = "null" ]; then
    jq -cn '{text:"..󰔄", tooltip:""}'
else
    jq -cn --arg t "${T}󰔄" --arg tt "${MN}󰔄 - ${MX}󰔄" '{text:$t, tooltip:$tt}'
fi
