#!/bin/bash
:
amixer -q set Master toggle && if amixer get Master | grep -Fq '[off]'; then volnoti-show -m; else volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1); fi
