#! /usr/bin/env ruby
#-*- coding: utf-8 -*-
# Author: Junpeng Qiu
# Date: <2015-10-07 Wed>
# Description: Fuse the building data into one json file

require 'rexml/document'
include REXML
require 'json'
require 'open-uri'

M_PSU_URL = 'http://m.psu.edu/'
BUILDING_OUTLINE_KML = M_PSU_URL + 'up_campus.kml'
BUILDING_DB_JSON = M_PSU_URL + 'bigmap/db_json'
#This needs to be further processed
#SHORTNAME_JSON = 'http://www.psumap.com/psumap.com/placemarks.js'
BUILDING_OUTLINE_KML_FILE = "#{ENV['HOME']}/tmp/up_campus.kml"
BUILDING_DB_JSON_FILE = "#{ENV['HOME']}/tmp/psu_buildings.json"
SHORTNAME_JSON_FILE = "#{ENV['HOME']}/tmp/placemarks.json"
OUTPUT_FILE="#{ENV['HOME']}/tmp/penn_state_buildings_data.json"

class SimplePlacemark
  attr_accessor :id, :coordinates

  def initialize(id, coordinates)
    @id = id
    @coordinates = coordinates
  end
end

kml = Document.new open(BUILDING_OUTLINE_KML_FILE)
placemarks = kml.elements.to_a('//Placemark')
placemarks = placemarks.map do |placemark|
  SimplePlacemark.new placemark.attributes['id'].strip, placemark.elements['*/*/*/*/coordinates'].texts[0].to_s.strip
end
puts placemarks.length

json = JSON.parse open(BUILDING_DB_JSON_FILE).read
json.each do |e|
  sp = placemarks.find { |p| p.id == e['building_id'] }
  if sp.nil?
    e['coordinates'] = nil
  else
    e['coordinates'] = sp.coordinates
  end
end
puts json.length

shortnames = JSON.parse open(SHORTNAME_JSON_FILE).read
json.each do |e|
  if shortnames[e['name']].nil?
    e['short_name'] = nil
  else
    e['short_name'] = shortnames[e['name']]['id']
  end
end

open(OUTPUT_FILE, 'w') do |file|
  file.write(json.to_json)
end
