#!/bin/bash

#Opens the given directory in Konsole terminal
#and brings the Konsole window to the foreground.
#The windows created before Konsole window must 
#not contain word "konsole" in them (like for example
#Vim editing this file:)

konsole  --new-tab --workdir  $1
wmctrl -x -a "konsole"

