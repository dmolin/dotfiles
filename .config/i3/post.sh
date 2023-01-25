#!/bin/bash
:
~/.config/i3/killAndWait.sh pcloud
~/Applications/pcloud &>/dev/null &

#~/.config/awesome/scripts/killAndWait.sh filen
#~/Applications/filen-setup.AppImage &>/dev/null &

~/.config/i3/killAndWait.sh redshift
redshift -P &>/dev/null &

~/.config/xborders/launch.sh &
systemctl --user start xscreensaver

#xset dpms 0 0 1800
#xset s 1800
