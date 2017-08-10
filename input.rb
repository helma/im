#!/usr/bin/env ruby
if STDIN.tty?
  ARGV.empty? ? FILES = `ls -t /home/ch/images/art/*`.split("\n") : FILES = ARGV
else
  FILES = STDIN.readlines.collect{|l| l.chomp}
end

def group_ids files
  `exiv2 -K Xmp.xmpMM.MotifID #{files.join " "} 2>/dev/null`.split("\n").collect{|l| l.split(/\s+/).last}.compact.sort.uniq
end

def group_files query_files
  gids = group_ids(query_files)
  (query_files + `exiv2 -K Xmp.xmpMM.MotifID #{FILES.join " "} 2>/dev/null`.split("\n").collect do |l|
    l = l.split(/\s+/)
    l.first if gids.include? l.last
  end).flatten.compact.uniq
end
