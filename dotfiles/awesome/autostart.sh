#!/bin/bash

compton

xrandr --output HDMI-1 --mode 1920x1080 --rate 144 
xrandr --output DP-0 --mode 3840x2160 --scale 0.5x0.5 --rate 60 --right-of HDMI-0

sleep 0.5

nitrogen --set-zoom-fill --random --head=0 ~/.config/.wallpapers
nitrogen --set-zoom-fill --random --head=1 ~/.config/.wallpapers

betterlockscreen -u ~/.config/.wallpapers
