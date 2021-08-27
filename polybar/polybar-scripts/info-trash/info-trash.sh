#!/bin/sh

case "$1" in
    --clean)
        trash-empty
        notify-send "Trash empied!"
        ;;
    *)
        files=`trash-list | wc -l`
        if [ $files -eq 0 ]; then
          echo ""
        else
          echo " `trash-list | wc -l`"
        fi
        ;;
esac
