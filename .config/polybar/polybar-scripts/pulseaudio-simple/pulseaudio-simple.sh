#!/bin/sh

# check if pamixer is running
pamixer 2>/dev/null
if [ $? -ne 0 ]; then
  #pamixer not running or in error
  echo ""
  exit 1
fi

volume = `amixer sget Master | grep "Front Left:" | awk '{ print $5 }'`
#muted=$(pamixer --get-mute)


if [ "$muted" = true ]; then
    echo "--"
else
    volume=$(pamixer --get-volume)

    if [ "$volume" -gt 49 ]; then
        echo "$volume"
    else
        echo "$volume"
    fi
fi
