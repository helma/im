#!/usr/bin/env ruby
require_relative "input.rb"
puts `exiv2 -K Xmp.xmp.Rating #{FILES} | grep '5$' | sed 's/  Xmp\.xmp\.Rating.*$//' | sed 's/^.*=//'`