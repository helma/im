#!/usr/bin/env ruby

old = ARGV.shift
new = ARGV.shift
file = ARGV.shift
i = `exiv2 -K Xmp.dc.subject #{file}`.split /\s+/
i.shift 3
subjects = i.join(" ").split ', '
pos = subjects.index(old)+1
`exiv2 -M"set Xmp.dc.subject[#{pos}] #{new}" "#{file}"` if pos
