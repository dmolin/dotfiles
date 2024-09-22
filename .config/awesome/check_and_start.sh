#!/bin/bash

# Function to check if a program is running, and if not, start it
check_and_start() {
    local program_name="$1"
    local start_command="$2"

    # Check if the program is running
    if ! pgrep -i "$program_name" > /dev/null
    then
        echo "$program_name is not running, starting it now..."
        # Start the program using the provided start command
        $start_command &
    else
        echo "$program_name is already running."
    fi
}
