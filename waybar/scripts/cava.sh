#!/usr/bin/env bash

bars=$(cat /tmp/cava.raw 2>/dev/null)

if [ -z "$bars" ]; then
  echo "▁▁▁▁▁▁"
  exit
fi

echo "$bars" | sed 's/;/ /g'
