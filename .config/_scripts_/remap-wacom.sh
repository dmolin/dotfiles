#!/bin/bash
:

# Re-enable when wacom tablet is connected
exit 0

penid=`xinput | grep "Pen stylus" --max-count=1 | awk 'BEGIN {FS="="} {print $2}' | awk '{print $1}'`
maindisplay=`xrandr --listactivemonitors | grep "*" | awk '{print $NF}'`

xinput map-to-output ${penid} ${maindisplay}
xsetwacom set ${penid} Button 2 "button +2"
