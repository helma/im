#!/usr/bin/env ruby
if STDIN.tty?
  if ARGV.empty? 
    FILES = `ls /home/ch/images/art/*`.gsub("\n"," ")
  else
    FILES = ARGV.join(" ")
  end
else
  FILES = STDIN.readlines.join(" ").gsub("\n","")
end
