#!/bin/bash
:
pidof $1 | xargs kill -TERM &>/dev/null
sleep 1
pidof $1 | xargs kill -KILL &>/dev/null

