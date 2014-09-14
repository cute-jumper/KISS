#! /bin/bash
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2014-09-14 Sun>

temp=$(sensors -A | sed '1d')
ip=$(ifconfig | grep -a1 'wlo1' | sed -n 's/.*inet \(.*\) net.*/\1/pg')

echo "$temp"
echo "IP address:     $ip"
