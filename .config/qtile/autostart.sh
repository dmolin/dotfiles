#!/bin/bash
:
#appimagelauncherd &
volnoti -a 0.9
hsetroot -root -fill ~/.config/qtile/wallpapers/aesthetic4k.jpg &
~/.config/picom/start_picom.sh &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
nm-applet &
#xfce4-power-manager &
pamac-tray &
blueman-applet &
blueman-tray &
~/.config/i3/killAndWait.sh pcloud
~/Applications/pcloud &>/dev/null &

~/.config/i3/killAndWait.sh redshift
redshift -P &>/dev/null &

systemctl --user start xscreensaver

~/.config/qtile/reconfigure_screens
