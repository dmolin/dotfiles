#!/bin/bash
:
PICOM=$(pidof picom)
if [ ! -z "$PICOM" ]; then exit; fi
sleep 2
picom --experimental-backends -b --vsync --log-file /tmp/picom.log &

