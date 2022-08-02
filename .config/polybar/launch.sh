#!/bin/bash
:

VARIANT=$1
if [ ! -f ~/.config/polybar/config.ini."$VARIANT" ]; then
  VARIANT="i3"
fi

echo "Preparing to launch Polybar with variant $VARIANT"
sleep 2

echo "  -> killing running instances..."
# Terminate already running instances
killall -q polybar

DISPLAYS=`~/.config/_scripts_/set_displays.sh`
MAIN_DISPLAY=`echo $DISPLAYS | awk '{print $1}'`
TOP_DISPLAY=`echo $DISPLAYS | awk '{print $2}'`

export MAIN_DISPLAY
export TOP_DISPLAY

echo "  -> waiting a bit..."
sleep 2

# Launch bar1
echo "  -> starting new process..." | tee -a /tmp/polybar1.log
MAIN_DISPLAY=$MAIN_DISPLAY polybar -c ~/.config/polybar/config.ini.$VARIANT main >> /tmp/polybar1.log 2>&1 & disown

if [ "$MAIN_DISPLAY" != "$TOP_DISPLAY" ]; then
  echo " -> starting bar on secondary display..." | tee -a /tmp/polybar1.log
  TOP_DISPLAY=$TOP_DISPLAY polybar -c ~/.config/polybar/config.ini.$VARIANT left >> /tmp/polybar1.log 2>&1 & disown
fi
