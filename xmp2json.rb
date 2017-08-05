#!/usr/bin/env ruby
require 'json'
require_relative "input.rb"
meta = {}
`exiv2 -g Xmp #{FILES.join " "} 2>/dev/null`.each_line do |line|
  items = line.split(/\s+/)
  file = items.shift
  meta[file] ||= {}
  key = items.shift
  items.shift(2)
  items = items.join(" ").split(", ") if key == "Xmp.dc.subject"
  meta[file][key] = items
end
puts JSON.pretty_generate meta
