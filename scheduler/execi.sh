#! /bin/bash
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2014-01-28 Tue>

interval=$1
shift
while true
do
    sleep "$interval"
    for i in "$@";
    do
        eval $i
    done
done

