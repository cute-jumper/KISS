#! /bin/ruby
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2015-04-07 Tue>

require 'open-uri'
require 'json'

$BASE_URL = 'http://melpa.org/'
$DATA_FILE = File.join File.dirname(__FILE__), 'data.json'

old_data = File.exist?($DATA_FILE) ? JSON.load(open($DATA_FILE)) : nil
package_names = JSON.load(open($BASE_URL + 'recipes.json')).keys &
JSON.load(open($BASE_URL + 'archive.json')).keys

puts "Total packages: #{package_names.length}"
data = {"Total packages" => package_names.length}
data['my packages'] = {}

downloads = JSON.load(open($BASE_URL + 'download_counts.json'))

my_packages = %w(gscholar-bibtex ace-flyspell ace-pinyin) + ARGV
my_packages.each do |pkg_name|
  d = downloads[pkg_name]
  below_number = package_names.select do |name|
    downloads[name] < d
  end.length
  percent = below_number * 100.0 / package_names.length
  if old_data
    old_stats = old_data['my packages'][pkg_name]
    puts "#{pkg_name}\n\tdownloads: #{d}(#{old_stats['downloads']}), rank: #{below_number + 1}(#{old_stats['rank']}), \
percentile: %.2f(#{old_stats['percentile']})" % percent
  else
    puts "#{pkg_name}\n\tdownloads: #{d}, rank: #{below_number + 1}, \
percentile: %.2f" % percent
  end
  data['my packages'][pkg_name] = { "downloads" => d,
                                    "rank" => below_number + 1,                          
                                    "percentile" => "%.2f" % percent}
end
open($DATA_FILE, 'w') do |f|
  f.write(data.to_json)
end
