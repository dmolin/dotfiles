#!/bin/bash
:
pidof $1 | xargs kill -TERM &>/dev/null
pwait $1
