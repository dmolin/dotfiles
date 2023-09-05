#!/bin/bash
:

# identify the headphones first
DEVICE=`bluetoothctl devices | grep Shokz | awk '{print $2}'`

if [ -z "$DEVICE" ]; then
  # no value. abort
  exit 1
fi

echo "Starting on `date`" >> /tmp/toggle-headphones.log

# check for info
CONNECTED=`bluetoothctl info $DEVICE | grep "Connected" | awk '{print $2}'`

if [ "$CONNECTED" = "yes" ]; then
  # disconnect
  notify-send "Disconnecting bluetooth headphones..."
  bluetoothctl disconnect $DEVICE >> /tmp/toggle-headphones.log
else
  # connect
  notify-send "Connecting bluetooth headphones..."
  bluetoothctl connect $DEVICE >> /tmp/toggle-headphones.log
fi

notify-send "Done"
