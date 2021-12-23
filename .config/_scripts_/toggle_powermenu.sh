#!/bin/bash
:
BIN=~/Applications/eww/target/release
$BIN/eww windows | grep "*powermenu"
is_active=$(echo $?)

if [ $is_active -eq 0 ]; then 
	$BIN/eww close powermenu; 
else
	$BIN/eww open powermenu
fi
