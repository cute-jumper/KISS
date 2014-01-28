#! /usr/bin/env ruby
# -*- coding: utf-8 -*-
# Author: qjp
# Date: <2013-09-10 Tue>

require 'open-uri'

url = 'https://github.com/users/cute-jumper/contributions_calendar_data'
open(url) do |io|
  content = io.read
  r = eval content
  (r.select { |item| item[1] != 0}).each do |item|
    puts item.inspect
  end
end

