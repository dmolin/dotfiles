#!/bin/bash
:
pkill polybar
xrandr --output eDP --scale 1
~/.screenlayout/external.sh
~/.config/polybar/launch.sh &
#~/.config/i3/screentimeouts.sh
