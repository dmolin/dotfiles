#!/bin/bash
:
amixer -D pulse set Master $1 && volnoti-show $(amixer -D pulse get Master | grep -Po '[0-9]+(?=%)' | head -1)
