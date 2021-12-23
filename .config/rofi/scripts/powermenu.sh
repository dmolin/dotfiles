#!/bin/bash

# options to be displayed
#option0="\uf023 lock"
#option0="\uf023 lock"
#option1="\uf842 logout"
#option2=" reboot"
#option3="\uf011 shutdown"
option0="lock"
option1="logout"
option2="reboot"
option3="shutdown"

# options passed into variable
options="$option0\n$option1\n$option2\n$option3"

chosen="$(echo -e "$options" | rofi -lines 4 -dmenu -p "power" -config ~/.config/rofi/powermenu.rasi)"
#chosen="$(echo -e "$options" | rofi -lines 4 -dmenu -p "power")"
echo "chosen = $chosen"
case $chosen in
    $option0)
        betterlockscreen -l;;
    $option1)
        pkill xmonad;;
    $option2)
        systemctl reboot;;
    $option3)
        systemctl poweroff;;
esac
