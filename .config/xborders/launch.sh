#!/bin/bash
:
pkill xborders
cd ~/.config/xborders/xborders
git submodule update --init
~/.config/xborders/xborders/xborders --border-radius 8 --border-width 3 --border-red 250 --border-green 131 --border-blue 14 1>&2 2>/dev/null &

