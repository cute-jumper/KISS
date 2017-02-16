#! /bin/bash
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2016-04-15 Fri>
# Description: Setup key mappings

sleep 5

# caps_lock as ctrl
setxkbmap -option ctrl:swapcaps

# Swap menu and right alt
xmodmap -e "remove mod1 = Alt_R"
xmodmap -e "keycode 108 = Menu"
xmodmap -e "keycode 135 = Alt_R"
xmodmap -e "add mod1 = Alt_R"

# caps_lock as escape & ctrl
xcape
