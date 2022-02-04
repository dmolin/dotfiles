#!/bin/bash
:
~/.config/xmonad/scripts/killAndWait.sh pcloud
~/Applications/pcloud &>/dev/null &


~/.config/xmonad/scripts/killAndWait.sh redshift
redshift -P &>/dev/null &

~/.config/xmonad/scripts/killAndWait.sh trayer
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --padding 6 --transparent true --alpha 0.2 --tint 0x282c34 --height 18 --monitor 1 &>/dev/null &
