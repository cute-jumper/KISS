#! /bin/bash
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2016-09-13 Tue>
# Description: Toggle internal keyboard

kb_name='AT Translated Set 2 keyboard'

if xinput list "$kb_name" | grep -i --quiet disable; then
  xinput enable "$kb_name"
else
  xinput disable "$kb_name"
fi
