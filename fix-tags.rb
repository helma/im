#!/usr/bin/env ruby

meta = {}
`exiv2 -K Xmp.dc.subject ~/images/art/* 2>/dev/null`.each_line do |line|
  i = line.split(/\s+/)
  file = i.shift
  i.shift(3)
  subjects = i.join(" ").split(", ")
  ["Animals", "Flowers & Plants", "Landscape", "People"].each do |s|
    if subjects.include? s
      pos = subjects.index(s)+1
      new = s.downcase
      new = "plants" if s.match(/Flower/)
      `exiv2 -M"set Xmp.dc.subject[#{pos}] #{new}" "#{file}"` if pos
      p file, subjects, s, new, pos
    end
  end
end

=begin

old = ARGV.shift
new = ARGV.shift
file = ARGV.shift
i = `exiv2 -K Xmp.dc.subject #{file}`.split /\s+/
i.shift 3
subjects = i.join(" ").split ', '
pos = subjects.index(old)+1
`exiv2 -M"set Xmp.dc.subject[#{pos}] #{new}" "#{file}"` if pos
=end
