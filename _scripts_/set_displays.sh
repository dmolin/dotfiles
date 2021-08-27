#!/bin/bash
:

MONITORS=`xrandr --listactivemonitors | grep "Monitors" | awk '{print $2}'`
export MAIN_DISPLAY=`xrandr --listactivemonitors | grep "0:" | awk '{print $NF}'`
export TOP_DISPLAY=`xrandr --listactivemonitors | grep "1:" | awk '{print $NF}'`
export THIRD_DISPLAY=`xrandr --listactivemonitors | grep "2:" | awk '{print $NF}'`


if [ $MONITORS -eq 1 ]; then
  # only 1 display
  export TOP_DISPLAY=$MAIN_DISPLAY
  echo $MAIN_DISPLAY $TOP_DISPLAY
elif [ $MAIN_DISPLAY = "DP-2" ]; then
  export MAIN_DISPLAY=$TOP_DISPLAY
  export TOP_DISPLAY=$THIRD_DISPLAY
else
  echo $MAIN_DISPLAY $TOP_DISPLAY
fi

