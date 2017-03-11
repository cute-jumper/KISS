#! /usr/bin/env ruby
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2017-02-12 Sun>
# Description: Read search history for bing dict

require 'uri'
require 'set'
require 'sqlite3'

$DB_FILE = Dir.glob("#{File.expand_path('~/.mozilla/firefox')}/*.default/places.sqlite")[0]

db = SQLite3::Database.new $DB_FILE

rows =
  db.execute('select url from moz_places where url like "%bing.com/dict/search?%";')
rows = rows.map do |r|
  URI.unescape(/.*bing.com\/.*[\?&]q=(.*?)(?=&|$)/.match(r[0])[1]).strip.
    gsub('+' ,' ');
end.reject do |r|
  r.empty? or (not (r[/[a-zA-Z ]+/] == r)) or (r.length < 2)
end.to_set.to_a
puts rows
