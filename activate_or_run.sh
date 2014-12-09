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
    Brings forward/activates the first window of a given window class or its part.
    For showing class of the opened windows use 'wmctrl -lx' (it's the second column).

    If the window is another virtual desktop the desktop will be changed.

    If the window for the given program name has not been found the specified command
    will be executed."

    echo "    
    Usage:" $(basename ${BASH_SOURCE[0]}) "<WIN_CLASS> <COMMAND>

    <WIN_CLASS>     Window class or its part. For example for class 'gvim.Gvim ' the name
    'gvim' or 'Gvim' can be used. First window matched by this class will be activated.

    <COMMAND>       Command to be executed if no matching window is found. This should 
    be the the command which runs the new instance of the desired program."
}

#Detects if window is open
function is_open() {
    lines=$(wmctrl -x -l "$wm_class" | grep $wm_class| wc -l)
    if [ $lines -eq 0 ]; then
        return 1 #false
    else
        return 0 #true
    fi
}



wm_class=$1
open_command=$2

if [ "$#" -lt 1 ]; then 
    help 
    exit 1
fi


if is_open; then
    wmctrl -x -a "$1" #Select active window
else
    exec $open_command #Run command
fi


