#!/bin/bash
:
~/.config/i3/killAndWait.sh pcloud
~/Applications/pcloud &>/dev/null &

#~/.config/awesome/scripts/killAndWait.sh filen
#~/Applications/filen-setup.AppImage &>/dev/null &

~/.config/i3/killAndWait.sh redshift
redshift -P &>/dev/null &

~/.config/xborders/launch.sh &
