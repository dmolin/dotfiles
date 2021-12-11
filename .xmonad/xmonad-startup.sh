#!/bin/bash
:
#pkill xmobar
#xmobar -x 0 ~/.config/xmobar/xmobar.config &
pkill trayer
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --alpha 0.2 --tint 0x282c34 --height 18 --monitor 1 &
