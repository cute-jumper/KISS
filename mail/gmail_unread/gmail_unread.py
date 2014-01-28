#! /usr/bin/env python
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2014-01-27 Mon>

import os
import notify2
from urllib import request

gmail_feed = 'https://mail.google.com/mail/feed/atom'

def get_user_info():
    try:
        from PyKDE4.kdeui import KWallet
        wallet = KWallet.Wallet.openWallet(os.getlogin(), 0)
        wallet.setFolder(wallet.PasswordFolder())
        return list(wallet.readMap('Google')[-1].items())[0]
    except:
        import sys
        if len(sys.argv) != 3:
            print('Error! Please put username and password as command line parameters!')
            sys.exit(1)
        return sys.argv[1], sys.argv[2]
        
def install_feed_opener():
    '''The actual realm is: "New mail feed".    
    Modified based on:
    http://www.voidspace.org.uk/python/articles/authentication.shtml
    '''
    username, password = get_user_info()
    pm = request.HTTPPasswordMgrWithDefaultRealm()
    pm.add_password(None, gmail_feed, username, password)
    auth = request.HTTPBasicAuthHandler(pm)
    opener = request.build_opener(auth)
    request.install_opener(opener)

def get_unread_count():
    import feedparser
    install_feed_opener()
    feed = request.urlopen(gmail_feed).read()
    atom = feedparser.parse(feed)
    return atom['feed']['fullcount']
    
def send_notification(unread_count):
    if not int(unread_count):
        return
    image = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'gmail.jpg')
    notify2.init(__file__)
    n = notify2.Notification('Gmail未读邮件',
                         '共{num}封未读'.format(num=unread_count),
                         image
    )
    n.show()
    
    
if __name__ == '__main__':
    send_notification(get_unread_count())
