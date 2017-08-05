#!/usr/bin/env ruby
require "optparse"

options = {}
optparse = OptionParser.new do|opts|
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
  opts.on( '-a', '--add-tags TAGS', 'Add tags (comma separated)' ) do |t|
    options[:add_tags] = t.split ","
  end
  opts.on( '-d', '--delete-tags TAGS', 'Delete tags (comma separated)' ) do |t|
    options[:delete_tags] = t.split ","
  end
end
optparse.parse!

require_relative "input.rb"

if options[:add_tags]
  options[:add_tags].each{|tag| `exiv2  -M"set Xmp.dc.subject #{tag}" #{FILES.join " "}`}
end

if options[:delete_tags]
  FILES.each do |f|
    old_tags = `exiv2 -K Xmp.dc.subject #{f}`.gsub(',','').split /\s+/
    old_tags.shift 3
    `exiv2  -M"del Xmp.dc.subject" #{f}`
    (old_tags-options[:delete_tags]).each{|tag| `exiv2  -M"set Xmp.dc.subject #{tag}" #{f}`}
  end
end
