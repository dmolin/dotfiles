#!/bin/bash
:
pkill polybar
xrandr --output eDP --scale 0.85
~/.screenlayout/internal.sh
~/.config/polybar/launch.sh &
#~/.config/i3/screentimeouts.sh 
