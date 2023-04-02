#!/bin/bash
:

echo "  -> killing running instances..."
# Terminate already running instances
killall -q polybar

DISPLAYS=`~/.config/_scripts_/set_displays.sh`
MAIN_DISPLAY=`echo $DISPLAYS | awk '{print $1}'`
SIDE_DISPLAY=`echo $DISPLAYS | awk '{print $2}'`

echo "  -> waiting a bit..."
sleep 2

# Launch bar1
echo "  -> starting new process..." | tee -a /tmp/polybar1.log
MONITOR=$MAIN_DISPLAY polybar main >> /tmp/polybar1.log 2>&1 & disown

if [ "$MAIN_DISPLAY" != "$SIDE_DISPLAY" ]; then
  echo " -> starting bar on secondary display..." | tee -a /tmp/polybar1.log
  MONITOR=$SIDE_DISPLAY polybar left >> /tmp/polybar1.log 2>&1 & disown
fi
