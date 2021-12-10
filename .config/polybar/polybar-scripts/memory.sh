#!/bin/sh
:
free=`/usr/bin/free -m | grep "Mem:" | awk '{print $3}'`
let gb=$(($free / 1000))
let hundreds=$(($free % 1000))
echo "$gb.$((($hundreds + 5) / 10))"
