#! /bin/bash
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2016-02-23 Tue>
# Description: Space to Ctrl using xcape

sleep 5

#  _  __          _                         _
# | |/ /___ _   _| |__   ___   __ _ _ __ __| |
# | ' // _ \ | | | '_ \ / _ \ / _` | '__/ _` |
# | . \  __/ |_| | |_) | (_) | (_| | | | (_| |
# |_|\_\___|\__, |_.__/ \___/ \__,_|_|  \__,_|
#           |___/
setxkbmap -option caps:swapescape

# Map an unused modifier's keysym to the spacebar's keycode and make it a
# control modifier. It needs to be an existing key so that emacs won't
# spazz out when you press it. Hyper_L is a good candidate.
spare_modifier="Hyper_L"
xmodmap -e "keycode 65 = $spare_modifier"
xmodmap -e "remove mod4 = $spare_modifier" # hyper_l is mod4 by default
xmodmap -e "add Control = $spare_modifier"

# Map space to an unused keycode (to keep it around for xcape to
# use).
xmodmap -e "keycode any = space"

# Swap menu and right alt
xmodmap -e "remove mod1 = Alt_R"
xmodmap -e "keycode 108 = Menu"
xmodmap -e "keycode 135 = Alt_R"
xmodmap -e "add mod1 = Alt_R"

# Finally use xcape to cause the space bar to generate a space when tapped.
xcape -e "$spare_modifier=space" -t 1500
