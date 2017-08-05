#!/usr/bin/env ruby
require 'json'
require_relative "input.rb"
meta = {}
`exiv2 -p a #{FILES.join " "} 2>/dev/null`.each_line do |line|
  items = line.split(/\s+/)
  file = items.shift
  meta[file] ||= {}
  key = items.shift
  items.shift(2)
  items = items.join(" ").split(", ")
  items.size == 1 ?  meta[file][key] = items.first : meta[file][key] = items
end
puts JSON.pretty_generate meta
