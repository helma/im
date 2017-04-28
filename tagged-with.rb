#!/usr/bin/env ruby
#p ARGV.shift
#p ARGF.each_line.collect{|l| l.chomp}

subject = ARGV[0]
files = Dir["/home/ch/images/art/*"]
#puts files
tagged_files = []
`exiv2 -K Xmp.dc.subject ~/images/art/* 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  file = i.shift
  i.shift(3)
  subjects = i.join(" ").split(", ")
  puts file if subjects.include? subject
end
