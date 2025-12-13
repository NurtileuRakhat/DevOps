#!/bin/bash
export DISPLAY=:1
Xvfb :1 -screen 0 1024x768x24 &

vncserver :1 -geometry 1024x768 -depth 24

sleep 5

firefox --no-sandbox --disable-gpu --safe-mode --profile /tmp/firefox-profile "https://store.steampowered.com/category/indie/"

tail -f /dev/null
