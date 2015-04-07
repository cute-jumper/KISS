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

my_packages = %w(gscholar-bibtex ace-flyspell ace-pinyin)
my_packages.each do |pkg_name|
  d = downloads[pkg_name]
  percent = package_names.select do |name|
    downloads[name] < d
  end.length * 100.0 / package_names.length
  puts "#{pkg_name}\n\tdownloads: #{d}, percentile: %.2f" % percent
end


