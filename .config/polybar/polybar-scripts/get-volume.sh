#!/bin/sh

volume=`amixer sget Master | grep "Front Left:" | awk '{ print $5 }'`

if [ "$volume" = "[0%]" ]; then
    echo "--"
else
    echo "$volume"
fi
