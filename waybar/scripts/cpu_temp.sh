#!/usr/bin/env bash

# Buscar automáticamente el mejor sensor
for hwmon in /sys/class/hwmon/hwmon*; do
  name=$(cat "$hwmon/name" 2>/dev/null)

  if [[ "$name" == "k10temp" || "$name" == "coretemp" || "$name" == "zenpower" ]]; then
    for temp in "$hwmon"/temp*_input; do
      if [ -f "$temp" ]; then
        value=$(cat "$temp" 2>/dev/null)
        if [ -n "$value" ]; then
          temp_c=$((value / 1000))
          break 2
        fi
      fi
    done
  fi
done

# fallback si no encuentra nada
if [ -z "$temp_c" ]; then
  echo "{\"text\": \"N/A\", \"class\": \"normal\"}"
  exit 0
fi

# estados dinámicos
if [ "$temp_c" -ge 80 ]; then
  echo "{\"text\": \"🔥 $temp_c°C\", \"class\": \"critical\"}"
elif [ "$temp_c" -ge 65 ]; then
  echo "{\"text\": \" $temp_c°C\", \"class\": \"warning\"}"
else
  echo "{\"text\": \"❄ $temp_c°C\", \"class\": \"normal\"}"
fi
