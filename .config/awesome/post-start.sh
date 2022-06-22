#!/bin/bash
:
~/.config/awesome/scripts/killAndWait.sh pcloud
~/Applications/pcloud &>/dev/null &

#~/.config/awesome/scripts/killAndWait.sh filen
#~/Applications/filen-setup.AppImage &>/dev/null &

~/.config/awesome/scripts/killAndWait.sh redshift
redshift -P &>/dev/null &
