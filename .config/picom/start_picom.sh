#!/bin/bash
:
PICOM=$(pidof picom)
if [ ! -z "$PICOM" ]; then exit; fi
picom -b --no-vsync --log-file /tmp/picom.log &

