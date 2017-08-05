#!/usr/bin/env ruby
require "optparse"

options = {}
optparse = OptionParser.new do|opts|
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
  opts.on( '-r', '--ratings RATINGS', 'Filter ratings (comma separated)' ) do |r|
    r = "[#{r.gsub(',','|')}]" if r.match(',')
    options[:ratings] = r
  end
  opts.on( '-i', '--include-tags TAGS', 'Include tags (comma separated)' ) do |t|
    options[:include_tags] = t.split ","
  end
  opts.on( '-e', '--exclude-tags TAGS', 'Exclude tags (comma separated)' ) do |t|
    options[:exclude_tags] = t.split ","
  end
  opts.on( '-T', '--require-tags TAGS', 'Require tags (comma separated)' ) do |t|
    options[:require_tags] = t.split ","
  end
end
optparse.parse!

require_relative "input.rb"
files = FILES

if options[:ratings]
  files = `exiv2 -K Xmp.xmp.Rating #{files.join " "} | grep '#{options[:ratings]}$' | sed 's/  Xmp\.xmp\.Rating.*$//' | sed 's/^.*=//'`.split("\n")
end

if options[:include_tags]
  tagged_files = []
  `exiv2 -K Xmp.dc.subject #{files.join " "}`.each_line do |line|
    i = line.split(/\s+/)
    file = i.shift
    i.shift(3)
    tags = i.join(" ").split(", ")
    tagged_files << file unless (tags & options[:include_tags]).empty?
  end
  files = tagged_files
end

if options[:exclude_tags]
  tagged_files = []
  `exiv2 -K Xmp.dc.subject #{files.join " "}`.each_line do |line|
    i = line.split(/\s+/)
    file = i.shift
    i.shift(3)
    tags = i.join(" ").split(", ")
    tagged_files << file if (tags & options[:exclude_tags]).empty?
  end
  files = tagged_files
end

if options[:require_tags]
  tagged_files = []
  `exiv2 -K Xmp.dc.subject #{files.join " "}`.each_line do |line|
    i = line.split(/\s+/)
    file = i.shift
    i.shift(3)
    tags = i.join(" ").split(", ")
    tagged_files << file if (options[:require_tags]-tags).empty?
  end
  files = tagged_files
end

puts files.join "\n"
