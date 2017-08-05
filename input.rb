#!/usr/bin/env ruby
if STDIN.tty?
  ARGV.empty? ? FILES = `ls /home/ch/images/art/*`.split("\n") : FILES = ARGV
else
  FILES = STDIN.readlines.collect{|l| l.chomp}
end
