#! /usr/bin/env ruby
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2013-10-17 Thu>

################################################################################
# This script makes use of github's API to show language statistics
################################################################################
require 'open-uri'
require 'json'
require 'optparse'

require_relative 'rgithuby_utils'

$config = load_config

def with_token(url)
  "#{url}?access_token=#{$config['token']}"
end

def get_repo_list()
  open(with_token "https://api.github.com/users/#{$config['username']}/repos") do |repos_json|
    JSON.parse(repos_json.read).reject do |repo|
      $config['exclude_repos'].include? repo['name']
    end
  end
end

def reject_lang?(repo, lang)
  $config['exclude_langs'].include? lang or
    ($config['exclude_repo_langs'].has_key? repo and
     $config['exclude_repo_langs'][repo].include? lang)
end

def get_lang_stat(repos, debug=false)
  stat_table = Hash.new 0
  repos.each do |repo|
    puts "* repo name: #{repo['name']}" if debug
    open(with_token repo['languages_url']) do |lang_json|
      languages = JSON.parse(lang_json.read)
      (languages.reject { |lang,| reject_lang? repo['name'], lang }).each do |lang, bytes|
        stat_table[lang] += bytes
        puts "  - #{lang}: #{bytes} Bytes" if debug
      end
    end
    puts "" if debug
  end
  Hash[stat_table.sort_by { |k, v| -v }] # Convert array of pairs to Hash
end

def console_show_stat(stat_table)
  total_size = stat_table.values.inject 0, :+
  puts "* RESULTS:"
  stat_table.each do |lang, bytes|
    puts "  - #{lang}: #{bytes} Bytes, #{bytes * 100 /total_size}%"
  end
end

def gnuplot_show_stat(stat_table)
  require 'gnuplot'
  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.title "User Language Statistics"
      plot.xlabel "Language"
      plot.ylabel "Size"
      
      plot.xtics "offset character 1.5" # Adjust xlabels to center
      plot.style "fill solid 0.80 border lt -1" # Fill color
      plot.arbitrary_lines << "unset key"       # Cancel legend
      
      plot.data << Gnuplot::DataSet.new([stat_table.keys.map { |k| "\"#{k}\""}, stat_table.values]) do |ds|
        ds.using = "2:xtic(1)"
        ds.with  = "histogram"
      end
    end
  end
end

$options = {}
optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{__FILE__} [options]"
  $options[:console] = false
  opts.on("-c", "--console", "Output results in console") { $options[:console] = true }
  $options[:gnuplot] = false
  opts.on("-g", "--gnuplot", "Output results using gnuplot") { $options[:gnuplot] = true }
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end

optparse.parse!

if $options[:console] or $options[:gnuplot]
  stat_table = get_lang_stat get_repo_list
else
  puts optparse
  exit 1
end

console_show_stat stat_table if $options[:console]
gnuplot_show_stat stat_table if $options[:gnuplot]
