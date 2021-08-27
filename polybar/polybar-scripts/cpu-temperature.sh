#!/bin/bash
:
TEMP=`sensors | grep Tctl | sed s/+// | awk '{print $2}'`

if [ "$TEMP" = "" ]; then
  TEMP=`sensors | grep "Package" | awk '{print $4}'`
fi
echo $TEMP
