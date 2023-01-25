#!/bin/bash
:
PICOM=$(pidof picom)
if [ ! -z "$PICOM" ]; then exit; fi
picom -b --vsync --log-file /tmp/picom.log &

