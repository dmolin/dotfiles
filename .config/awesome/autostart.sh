#!/bin/bash
:

# Function to check if a program is running, and if not, start it
check_and_start() {
    local program_name="$1"
    local start_command="$2"

    # Check if the program is running
    if ! pgrep -i "$program_name" > /dev/null
    then
        echo "$program_name is not running, starting it now..."
        # Start the program using the provided start command
        $start_command &>/dev/null &
    else
        echo "$program_name is already running."
    fi
}

#appimagelauncherd &
check_and_start "volnoti" "volnoti -a 0.9"

hsetroot -root -fill ~/.config/qtile/wallpapers/aesthetic4k.jpg &
~/.config/picom/start_picom.sh &

check_and_start "polkit-gnome" "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
check_and_start "nm-applet" "nm-applet"
check_and_start "pamac-tray" "pamac-tray"
check_and_start "blueman-applet" "blueman-applet"
check_and_start "blueman-tray" "blueman-tray"
check_and_start "pcloud" "/home/user/bin/pcloud"
check_and_start "redshift" "redshift -P"

systemctl --user start xscreensaver
check_and_start "cryptomator" "cryptomator"

# Map wacom stylus to main screen
# ~/.config/_scripts_/remap-wacom.sh &

# ~/.config/qtile/reconfigure_screens

check_and_start "xscreensaver" "xscreensaver -no-splash"

# disable scroll lock
# this has been moved to .xprofile. if it doesn't work, re-enable it here
# setxkbmap -option "ctrl:nocaps"

# this has been moved to .xprofile. if it doesn't work, re-enable it here
# xmodmap ~/.Xmodmap
