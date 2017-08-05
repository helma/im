#!/usr/bin/env ruby
require_relative "input.rb"
grouped = `exiv2 -K Xmp.xmpMM.MotifID #{FILES.join " "} 2>/dev/null | cut -f1 -d ' '`.split "\n"
selected = `exiv2 -K Xmp.xmpMM.MotifSelected #{FILES.join " "} 2>/dev/null | cut -f1 -d ' '`.split "\n"
puts (FILES-grouped+selected).sort.join "\n"
