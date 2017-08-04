#!/usr/bin/env ruby
require 'fileutils'
require 'securerandom'
require 'json'

METADIR = "/home/ch/images/metadata"
FileUtils.mkdir_p METADIR

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
files.each_with_index do |f,i|
  rgb1 = get_rgb f
  matrix[i] ||= []
  matrix[i][i] = 0.0
  (i+1..files.size-1).each do |j|
    rgb2 = get_rgb files[j]
    #dist = cosine([rgb1,rgb2])
    dist = euclid([rgb1,rgb2])
    matrix[i][j] = dist 
    matrix[j] ||= []
    matrix[j][i] = dist 
  end
end

q = SecureRandom.random_number(files.size)
header = []
dist = []
matrix[q].sort[0..9].each_with_index do |d,k|
  i = matrix[q].index(d)
  header[k] = files[i]
end

header.each_with_index do |f,i|
  mi = files.index(f)
  dist[i] ||= []
  (i..9).each do |j|
    dist[j] ||= []
    mj = files.index(header[j])
    dist[i][j] = matrix[mi][mj]
    dist[j][i] = matrix[mi][mj]
  end
end

#puts header.join("\n")
File.open("/tmp/dist.csv","w+") do |f|
  dist.each_with_index{|dist,i| f.puts dist.join(",")}
end

#puts `Rscript tsp.R`.split(" ").collect{|f| f.sub(/^X/,"/home/ch/images/art/")}.join("\n")
puts `Rscript tsp.R`.split(" ").collect{|v| header[v.sub('V','').to_i-1]}.join("\n")
