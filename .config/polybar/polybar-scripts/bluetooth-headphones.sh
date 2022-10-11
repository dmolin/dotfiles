#!/bin/bash
:

# identify the headphones first
DEVICE=`bluetoothctl devices | awk '{print $2}'`


if [ -z "$DEVICE" ]; then
  # no value. abort
  echo ""
  exit 1
fi

# device found. check if we're connected
CONNECTED=`bluetoothctl info $DEVICE | grep "Connected" | awk '{print $2}'`


if [ "$CONNECTED" = "yes" ]; then
  echo ""
else
  echo ""
fi
