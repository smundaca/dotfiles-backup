#!/usr/bin/env bash

HISTORY_FILE="/tmp/cpu_hist"

[ -f "$HISTORY_FILE" ] || echo "0" > "$HISTORY_FILE"

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
prev_total=$(cat /tmp/cpu_prev_total 2>/dev/null || echo 0)
prev_idle=$(cat /tmp/cpu_prev_idle 2>/dev/null || echo 0)

total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_all=$((idle + iowait))

diff_total=$((total - prev_total))
diff_idle=$((idle_all - prev_idle))

if [ "$diff_total" -gt 0 ]; then
  usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
else
  usage=0
fi

echo "$total" > /tmp/cpu_prev_total
echo "$idle_all" > /tmp/cpu_prev_idle

echo "$usage" >> "$HISTORY_FILE"
tail -n 20 "$HISTORY_FILE" > "${HISTORY_FILE}.tmp" 2>/dev/null

if [ -s "${HISTORY_FILE}.tmp" ]; then
  cp "${HISTORY_FILE}.tmp" "$HISTORY_FILE"
fi

graph=$(awk '{
  if($1<20) printf "▁";
  else if($1<40) printf "▂";
  else if($1<60) printf "▃";
  else if($1<80) printf "▅";
  else printf "▇";
}' "$HISTORY_FILE")

echo "{\"text\":\"CPU $graph\",\"tooltip\":\"Historial de carga del CPU\",\"class\":\"normal\"}"