#!/usr/bin/env ruby
all = Dir["/home/ch/images/art/*"]
grouped = `exiv2 -K Xmp.xmpMM.MotifID /home/ch/images/art/* 2>/dev/null | cut -f1 -d ' '`.split "\n"
puts (all - grouped).join "\n"
