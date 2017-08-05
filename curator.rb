#!/usr/bin/env ruby
require 'fileutils'
require 'securerandom'
require "optparse"
require 'json'

METADIR = "/home/ch/images/metadata"
FileUtils.mkdir_p METADIR

options = {}
options[:nr] = 10
optparse = OptionParser.new do|opts|
  opts.on( '-h', '--help', 'Display this screen' ) do
    puts opts
    exit
  end
  opts.on( '-n', '--number COUNT', 'Number of similar images' ) do |n|
    options[:nr] = n.to_i
  end
  opts.on( '-q', '--query IMAGE', 'Query image' ) do |i|
    options[:query] = i
  end
end
optparse.parse!

require_relative 'input.rb'

def get_rgb file
  meta_file = File.join METADIR, File.basename(file)+".rgb.json"
  if File.exists? meta_file and FileUtils.uptodate?(meta_file,[file])
    JSON.parse File.read(meta_file)
  else
    s = `convert #{file} -resize 16x16! -depth 16 -colorspace RGB -compress none PGM:-`.split("\n")[3..-1]
    rgb = s.collect{|l| l.split(" ").collect{|v| v.to_f}}.flatten
    File.open(meta_file,"w+"){|f| f.puts rgb.to_json}
    rgb
  end
end

def dot_product(a, b)
  products = a.zip(b).map{|a, b| a * b}
  products.inject(0) {|s,p| s + p}
end

def magnitude(point)
  squares = point.map{|x| x ** 2}
  Math.sqrt(squares.inject(0) {|s, c| s + c})
end

def euclid scaled_properties
  sq = scaled_properties[0].zip(scaled_properties[1]).map{|a,b| (a - b) ** 2}
  Math.sqrt(sq.inject(0) {|s,c| s + c})
end

def cosine scaled_properties
  dot_product(scaled_properties[0], scaled_properties[1]) / (magnitude(scaled_properties[0]) * magnitude(scaled_properties[1]))
end

files = ARGV
matrix = []
FILES.each_with_index do |f,i|
  rgb1 = get_rgb f
  matrix[i] ||= []
  matrix[i][i] = 0.0
  (i+1..FILES.size-1).each do |j|
    rgb2 = get_rgb FILES[j]
    #dist = cosine([rgb1,rgb2])
    dist = euclid([rgb1,rgb2])
    matrix[i][j] = dist 
    matrix[j] ||= []
    matrix[j][i] = dist 
  end
end

if options[:query]
  q = FILES.index(options[:query])
else
  q = SecureRandom.random_number(FILES.size)
end
header = []
dist = []
matrix[q].sort[0..options[:nr]-1].each_with_index do |d,k|
  i = matrix[q].index(d)
  header[k] = FILES[i]
end

header.each_with_index do |f,i|
  mi = FILES.index(f)
  dist[i] ||= []
  (i..options[:nr]-1).each do |j|
    dist[j] ||= []
    mj = FILES.index(header[j])
    dist[i][j] = matrix[mi][mj]
    dist[j][i] = matrix[mi][mj]
  end
end

File.open("/tmp/dist.csv","w+") do |f|
  dist.each_with_index{|dist,i| f.puts dist.join(",")}
end

puts `Rscript tsp.R`.split(" ").collect{|v| header[v.sub('V','').to_i-1]}.join("\n")
