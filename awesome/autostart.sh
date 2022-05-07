#!/bin/bash

compton

sleep 0.5

xrandr --output HDMI-1 --mode 1920x1080 --rate 144 --output DP-0 --auto --right-of HDMI-1

nitrogen --set-zoom-fill --random --head=0 ~/.config/.wallpapers
nitrogen --set-zoom-fill --random --head=1 ~/.config/.wallpapers
