#!/usr/bin/env bash

if ! command -v nvidia-smi &> /dev/null; then
  echo "{\"text\": \"No GPU\", \"class\": \"normal\"}"
  exit 0
fi

temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits 2>/dev/null)
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null)

if [ -z "$temp" ]; then
  echo "{\"text\": \"GPU N/A\", \"class\": \"normal\"}"
  exit 0
fi

if [ "$temp" -ge 80 ]; then
  echo "{\"text\": \"🔥 GPU $temp°C $usage%\", \"class\": \"critical\"}"
elif [ "$temp" -ge 60 ]; then
  echo "{\"text\": \" GPU $temp°C $usage%\", \"class\": \"warning\"}"
else
  echo "{\"text\": \"🎮 GPU $temp°C $usage%\", \"class\": \"normal\"}"
fi
