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

puts "Total packages: #{package_names.length}" + (old_data ?
                                                    "(#{old_data['Total packages']})" : "")
data = {"Total packages" => package_names.length}
data['my packages'] = {}

downloads = JSON.load(open($BASE_URL + 'download_counts.json'))

package_names &= downloads.keys

my_packages =
  %w(gscholar-bibtex ace-flyspell ace-pinyin ace-jump-helm-line fcitx bing-dict avy-zap) + ARGV

avg_downloads = 0
avg_rank = 0

my_packages.each do |pkg_name|
  d = downloads[pkg_name]
  next if d.nil?
  below_number = package_names.select do |name|
    downloads[name] < d
  end.length
  percent = below_number * 100.0 / package_names.length
  old_stats = old_data['my packages'][pkg_name] if old_data and old_data['my packages']
  if old_stats
    puts "#{pkg_name}\n\tdownloads: #{d}(#{old_stats['downloads']}), rank: #{below_number + 1}(#{old_stats['rank']}), \
percentile: %.2f(#{old_stats['percentile']})" % percent
  else
    puts "#{pkg_name}\n\tdownloads: #{d}, rank: #{below_number + 1}, \
percentile: %.2f" % percent
  end
  data['my packages'][pkg_name] = { "downloads" => d,
                                    "rank" => below_number + 1,
                                    "percentile" => "%.2f" % percent}
  avg_downloads += d
  avg_rank += below_number + 1
end
puts '-' * 80
puts "Average downloads: #{avg_downloads / my_packages.length}\n\
Average rank: #{avg_rank / my_packages.length}"
open($DATA_FILE, 'w') do |f|
  f.write(data.to_json)
end
