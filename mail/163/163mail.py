#!/usr/bin/env python2
#-*- coding:utf-8 -*-
#author: Junpeng Qiu
import imaplib, os, pynotify, sys

username = sys.argv[1]
password = sys.argv[2]

image = os.path.join(os.path.dirname(os.path.abspath(__file__)), '163.png')
mail = imaplib.IMAP4_SSL('imap.163.com')
# mail = imaplib.IMAP4_SSL('imap.gmail.com')
mail.login(username, password)
mail.list()
# Out: list of "folders" aka labels in gmail.
mail.select() # connect to inbox.
unread = int(mail.status("inbox", "(UNSEEN)")[1][0].split()[2][:-1])
if unread:
    pynotify.init("163未读邮件")
    n = pynotify.Notification("163未读邮件", '共%d封未读' %unread, image)
    n.set_hint_string('x-canonical-append','')
    n.show()
