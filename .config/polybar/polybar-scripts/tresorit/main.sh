#!/bin/sh

case "$1" in
    --toggle)
        if [ "$(pgrep tresorit -x)" ]; then
            pkill -fx tresorit
        else
            ~/.local/share/tresorit/tresorit --hidden &
        fi
        ;;
    *)
        if [ "$(pgrep tresorit -x)" ]; then
            echo "#1"
        else
            echo "#2"
        fi
        ;;
esac
