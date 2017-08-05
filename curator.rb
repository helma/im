#!/usr/bin/env ruby
require 'fileutils'
require 'securerandom'
require "optparse"
require 'json'

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

fingerprints = {}
`exiv2 -q -P v -g "Xmp.xmpMM.Fingerprint" #{FILES.join " "}`.split("\n").each do |l|
  file,value_str = l.split(/\s+/)
  fingerprints[file] = JSON.parse value_str
end

(FILES-fingerprints.keys).each do |file|
    s = `convert #{file} -resize 16x16! -depth 16 -colorspace RGB -compress none PGM:-`.split("\n")[3..-1]
    fingerprint = s.collect{|l| l.split(" ").collect{|v| v.to_f}}.flatten
    `exiv2 -M"set Xmp.xmpMM.Fingerprint #{fingerprint.to_json}" #{file}`
    fingerprints[file] = fingerprint
end

if options[:query] and !fingerprints.keys.include?(options[:query])
  s = `convert #{options[:query]} -resize 16x16! -depth 16 -colorspace RGB -compress none PGM:-`.split("\n")[3..-1]
  fingerprint = s.collect{|l| l.split(" ").collect{|v| v.to_f}}.flatten
  fingerprints[options[:query]] = fingerprint
end

options[:query] ? query_file = options[:query] : query_file = fingerprints.keys[SecureRandom.random_number(fingerprints.keys.size)]

query_fingerprint = fingerprints[query_file]
selection = fingerprints.collect{|f,fp| [f,euclid([query_fingerprint,fp])]}.sort{|a,b| a[1] <=> b[1]}.collect{|i| i[0]}[0..options[:nr]-1]

dist = []
selection.each_with_index do |f,i|
  dist[i] ||= []
  (i..options[:nr]-1).each do |j|
    dist[j] ||= []
    d = euclid([fingerprints[f],fingerprints[selection[j]]])
    dist[i][j] = d
    dist[j][i] = d
  end
end

File.open("/tmp/dist.csv","w+") do |f|
  dist.each_with_index{|dist,i| f.puts dist.join(",")}
end

puts `Rscript tsp.R`.split(" ").collect{|v| selection[v.sub('V','').to_i-1]}.join("\n")
