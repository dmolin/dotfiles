#!/bin/bash
:

MONITORS=`xrandr --listactivemonitors | grep "Monitors" | awk '{print $2}'`

MAIN_DISPLAY=`xrandr --listactivemonitors | grep "0:" | awk '{print $NF}'`
TOP_DISPLAY=`xrandr --listactivemonitors | grep "1:" | awk '{print $NF}'`


if [ $MONITORS -eq 1 ]; then
  # only 1 display
  TOP_DISPLAY=$MAIN_DISPLAY
fi

export MAIN_DISPLAY=$MAIN_DISPLAY 
export TOP_DISPLAY=$TOP_DISPLAY

echo $MAIN_DISPLAY $TOP_DISPLAY
