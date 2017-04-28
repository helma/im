#!/usr/bin/env ruby

subject = ARGV[0]
files = Dir["/home/ch/images/art/*"]
#puts files
tagged_files = []
`exiv2 -p a ~/images/art/* 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  file = i.shift
  key = i.shift
  if key == "Xmp.dc.subject"
    i.shift(2)
    subjects = i.join(" ").split(", ")
    tagged_files << file if subjects.include? subject
  end
end
#puts tagged_files
puts (files-tagged_files).sort.reverse.join("\n")
