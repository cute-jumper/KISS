#! /bin/ruby
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2015-04-07 Tue>

require 'open-uri'
require 'json'

$BASE_URL='http://melpa.org/'

package_names = JSON.load(open($BASE_URL + 'recipes.json')).keys &
JSON.load(open($BASE_URL + 'archive.json')).keys

puts "Total packages: #{package_names.length}"

downloads = JSON.load(open($BASE_URL + 'download_counts.json'))

my_packages = %w(gscholar-bibtex ace-flyspell ace-pinyin) + ARGV
my_packages.each do |pkg_name|
  d = downloads[pkg_name]
  below_number = package_names.select do |name|
    downloads[name] < d
  end.length
  percent = below_number * 100.0 / package_names.length
  puts "#{pkg_name}\n\tdownloads: #{d}, rank: #{below_number + 1}, \
percentile: %.2f" % percent
end


