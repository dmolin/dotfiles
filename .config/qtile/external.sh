#!/bin/bash
:
#xrandr --output eDP --scale 1
~/.screenlayout/external.sh
pkill -SIGUSR1 qtile
hsetroot -root -fill ~/.config/qtile/wallpapers/aesthetic4k.jpg
