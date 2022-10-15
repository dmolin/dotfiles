#!/bin/sh

PATH_AC="/sys/class/power_supply/AC0"
PATH_BATTERY_0="/sys/class/power_supply/BAT0"
PATH_BATTERY_1="/sys/class/power_supply/BAT1"

ac=0
battery_level_0=0
battery_level_1=0
battery_max_0=0
battery_max_1=0

if [ ! -d "$PATH_AC" ]; then
  exit
fi

if [ -f "$PATH_AC/online" ]; then
    ac=$(cat "$PATH_AC/online")
fi

if [ -f "$PATH_BATTERY_0/charge_now" ]; then
    battery_level_0=$(cat "$PATH_BATTERY_0/charge_now")
fi

if [ -f "$PATH_BATTERY_0/charge_full" ]; then
    battery_max_0=$(cat "$PATH_BATTERY_0/charge_full")
fi

if [ -f "$PATH_BATTERY_1/charge_now" ]; then
    battery_level_1=$(cat "$PATH_BATTERY_1/charge_now")
fi

if [ -f "$PATH_BATTERY_1/charge_full" ]; then
    battery_max_1=$(cat "$PATH_BATTERY_1/charge_full")
fi

battery_level=$(("$battery_level_0 + $battery_level_1"))
battery_max=$(("$battery_max_0 + $battery_max_1"))

battery_percent=$(("$battery_level * 100"))
battery_percent=$(("$battery_percent / $battery_max"))

color_pre=""
color_post=""

if [ "$ac" -eq 1 ]; then
    icon=""

    if [ "$battery_percent" -gt 98 ]; then
        echo "%{FB5C7B9}$icon%{F} PWR"
    else
        echo "$icon $battery_percent%"
    fi
else
    color_pre="%{F33E014}"

    if [ "$battery_percent" -gt 98 ]; then
	icon=""
    elif [ "$battery_percent" -gt 92 ]; then
	color_pre="%{F3BAD18}"
        icon=""
    elif [ "$battery_percent" -gt 85 ]; then
        icon=""
    elif [ "$battery_percent" -gt 75 ]; then
        icon=""
    elif [ "$battery_percent" -gt 60 ]; then
	color_pre="%{FA4AD2E}"
        icon=""
    elif [ "$battery_percent" -gt 49 ]; then
        icon=""
    elif [ "$battery_percent" -gt 40 ]; then
	color_pre="%{FEFD35A}"
        icon=""
    elif [ "$battery_percent" -gt 30 ]; then
        icon=""
    elif [ "$battery_percent" -gt 20 ]; then
	color_pre="%{FE09705}"
        icon=""
    elif [ "$battery_percent" -gt 10 ]; then
	color_pre="%F{FF5708}"
        icon=""
    elif [ "$battery_percent" -gt 5 ]; then
        icon=""
    else
        icon="BATT"
    fi

    if [ "$color_pre" != "" ]; then	
        color_post="%{F}"
    fi
    echo "${color_pre}$icon $battery_percent%${color_post}"
fi
