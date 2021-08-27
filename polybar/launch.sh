#!/bin/bash
:

echo "Preparing to launch Polybar"
sleep 2

echo "  -> killing running instances..."
# Terminate already running instances
killall -q polybar

DISPLAYS=`~/.config/_scripts_/set_displays.sh`
MAIN_DISPLAY=`echo $DISPLAYS | awk '{print $1}'`
TOP_DISPLAY=`echo $DISPLAYS | awk '{print $2}'`

#echo $MAIN_DISPLAY $TOP_DISPLAY

export MAIN_DISPLAY
export TOP_DISPLAY

echo "  -> waiting a bit..."
sleep 2

# Wait until the process has been properly shut down
#while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Launch bar1
echo "  -> starting new process..." | tee -a /tmp/polybar1.log
MAIN_DISPLAY=$MAIN_DISPLAY polybar -c ~/.config/polybar/config.ini main >> /tmp/polybar1.log 2>&1 & disown

if [ "$MAIN_DISPLAY" != "$TOP_DISPLAY" ]; then
  echo " -> starting bar on secondary display..." | tee -a /tmp/polybar1.log
  TOP_DISPLAY=$TOP_DISPLAY polybar -c ~/.config/polybar/config.ini top >> /tmp/polybar1.log 2>&1 & disown
fi

