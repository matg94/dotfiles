#!/bin/bash

sleep 0.5
compton

xrandr --output HDMI-1 --mode 1920x1080 --rate 144 --output DP-0 --auto --right-of HDMI-1
sudo wpa_supplicant -i wlp6s0 -B -c/etc/wpa_supplicant.conf > /dev/null
sudo dhclient wlp6s0 > /dev/null