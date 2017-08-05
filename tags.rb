#!/usr/bin/env ruby
require_relative "input.rb"

subjects = []
`exiv2 -K Xmp.dc.subject #{FILES.join " "} 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  i.shift(4)
  subjects += i.join(" ").split(", ")
end
puts subjects.uniq.sort.join "\n"
