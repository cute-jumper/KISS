#! /usr/bin/env ruby
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2016-01-08 Fri>
# Description: RSS Notifier in Ruby

require 'rss'
require 'open-uri'
require 'libnotify'
require 'eventmachine'

$RSS_URLS = %w(http://rss.cnbeta.com/rss https://news.ycombinator.com/rss)
$INTERVAL = 60 * 30
$TIMEOUT = 15
$ICON_PATH  = "#{File.join(File.expand_path(File.dirname(__FILE__)), 'rss_notifier_icon.png')}"

$CACHE = $RSS_URLS.map { |e| [e,[]] }.to_h

def show_rss_titles
  $RSS_URLS.each do |url|
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      titles = feed.items.map(&:title)
      notified_titles = titles - $CACHE[url]
      $CACHE[url] |= titles
      Libnotify.show(:summary => feed.channel.title,
                     :body => notified_titles.join("\n"),
                     :timeout => $TIMEOUT,
                     :icon_path => $ICON_PATH
                    ) unless notified_titles.empty?
    end
    sleep $TIMEOUT + 1
  end
end

show_rss_titles

EventMachine::run do
  EventMachine::PeriodicTimer.new($INTERVAL) do
    show_rss_titles
  end
end
