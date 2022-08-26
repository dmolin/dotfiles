#!/bin/bash
:
PICOM=$(pidof picom)
if [ ! -z "$PICOM" ]; then exit; fi
picom --experimental-backends -b --vsync --log-file /tmp/picom.log &

