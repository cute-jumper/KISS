#! /usr/bin/env ruby
# -*- coding: utf-8 -*-
# Author: qjp
# Date: <2013-09-10 Tue>

################################################################################
# Parse the Github commit history, and remind the user of how long he or she
# has not been coding since last commit.
# Simple and stupid!
################################################################################
require 'rss'
require 'open-uri'
require 'time'
require 'libnotify'

if ARGV.include? '-h' or ARGV.include? '--help'
  puts "Usage: ruby #{__FILE__} [pathtoicon]"
  exit 0
end

$NOTIFICATION_TITLES = [[0, "温馨提示"],
                        [86400, "友情提醒"],
                        [259200, "郑重提醒"],
                        [604800, "严重警告"]]

def parse_atom(url)
  regex = /<.*?>(.*)<\/.*>/m
  strip_tags = lambda do |str|
    regex.match(str)[1]
  end
  open(url) do |atom|
    feed = RSS::Parser.parse(atom)
    latest = feed.items.detect do |item|
      item.title.to_s.include?("pushed")
    end
    date = strip_tags.call(latest.title.to_s)
    time = strip_tags.call(latest.updated.to_s)
    (Time.new - Time.parse("#{date} #{time} UTC")).to_i
  end
end

url = 'https://github.com/cute-jumper.atom'
total_seconds = parse_atom(url)
mm, ss = total_seconds.divmod(60)
hh, mm = mm.divmod(60)
dd, hh = hh.divmod(24)
title = $NOTIFICATION_TITLES.reverse.detect { |x, y| x < total_seconds}[1]
Libnotify.show(:summary => title,
               :body => "你已经有 #{total_seconds} 秒没有写代码了！\n也就是： #{dd}天 #{hh}小时 #{mm}分钟 #{ss}秒！！！",
               :icon_path => ARGV[0])

