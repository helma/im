#!/usr/bin/env ruby
require_relative "input.rb"
tagged_files = []
`exiv2 -K Xmp.dc.subject #{FILES.join(" ")} 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  tagged_files << i.shift
end
puts (FILES-tagged_files).sort.reverse.join("\n")
