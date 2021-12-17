#!/bin/bash
:
PICOM=$(pidof picom)
if [ $PICOM > 0 ]; then exit; fi
sleep 2
#picom --experimental-backends -b --vsync --log-file /tmp/picom.log &
picom --experimental-backends -b --vsync --log-file /tmp/picom.log &

