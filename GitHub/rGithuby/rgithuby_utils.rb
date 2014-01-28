#! /usr/bin/env ruby 
#-*- coding: utf-8 -*-
# Author: qjp
# Date: <2013-10-17 Thu>

def load_config
  require 'yaml'
  # First local, then defaults
  config_files = ["config.yaml", "default.yaml"]
  config_files.each do |fn|
    if File.exists? fn
      return YAML.load_file(fn)
    end
  end
  puts "\033[1;31m[Error]:\033[0m No configuration files found!  "\
    "Please provide a file named #{config_files.join(' or ')}."
  exit 1
end

