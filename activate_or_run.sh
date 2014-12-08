#!/bin/bash

#Simple script which selects a window of given app in EWMH/NetWM compatible X Window Manager
#or executes a given command to launch the application if the window could not be found.
#
#The typical usage would be to bind this script execution to a global keyboard shortcut to
#conveniently select/create application windows.
#
#For scrip to work the wmctrl command is required.

function help() {
    echo "    
    Brings forward/activates the first window of a program instance
    defined by the title or its part.

    If the window is another virtual desktop the desktop will be changed.

    If the window for the given program name has not been found the specified command
    will be executed."

    echo "    
    Usage:" $(basename ${BASH_SOURCE[0]}) "<TITLE_PART> <COMMAND>

    <TITLE_PART>    Title or its part of the window of the program instance.
                    For example both 'Chrome' and 'Google' will activate 'Google Chrome' 
                    titled window but also for example Firefox window will be activated 
                    with 'Google' in its title by 'Google' if its window was created 
                    before the Google Chrome's window.

    <COMMAND>       Command to be executed if no matching window is found. This should 
                    be the the command which runs the new instance of the desired program."

   
}

#Detects if window is open
function is_open() {
    lines=$(wmctrl -l "$title" | grep $title | wc -l)
    if [ $lines -eq 0 ]; then
        return 1 #false
    else
        return 0 #true
    fi
}



title=$1
open_command=$2

if [ "$#" -lt 1 ]; then 
    help 
    exit 1
fi


if is_open; then
    wmctrl -a "$1" #Select active window
else
    exec $open_command #Run command
fi


