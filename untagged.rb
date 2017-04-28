#!/usr/bin/env ruby

subject = ARGV[0]
files = Dir["/home/ch/images/art/*"]
#puts files
tagged_files = []
`exiv2 -K Xmp.dc.subject ~/images/art/* 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  tagged_files << i.shift
end
puts (files-tagged_files).sort.reverse.join("\n")
