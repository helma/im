#!/usr/bin/env ruby

subjects = []
`exiv2 -K Xmp.dc.subject /home/ch/images/art/*`.each_line do |line|
  i = line.split(/\s+/)
  i.shift(4)
  subjects += i.join.split(",")
end
puts subjects.uniq.sort.join "\n"
