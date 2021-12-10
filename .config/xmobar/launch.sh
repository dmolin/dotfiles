#!/bin/bash
:
SCREEN=$1

if [[ -z "$1" ]]; then
  SCREEN=0
fi
kill -9 `pgrep -f "xmobar -x $SCREEN"`
xmobar -x $SCREEN ~/.config/xmobar/xmobar.config &
