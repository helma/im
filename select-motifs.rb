#!/usr/bin/env ruby
require 'yaml'
require_relative 'input.rb'
meta = {}
motifs = {}

`exiv2 -g Xmp.xmpMM -g Xmp.xmp.Rating #{FILES.join " "}`.each_line do |line|
  file, id, type, size, value = line.chomp.split /\s+/
  meta[file] ||= {}
  meta[file][id] = value
end

meta.each do |file,metadata|
  if metadata["Xmp.xmpMM.MotifID"]
    motifs[metadata["Xmp.xmpMM.MotifID"]] ||= []
    motifs[metadata["Xmp.xmpMM.MotifID"]] << file
  elsif metadata["Xmp.xmpMM.MotifSelected"] 
    puts "Removing selection for empty motif: #{file}"
    `exiv2 -M"del Xmp.xmpMM.MotifSelected" #{file}`
  end
end

#motifs.each do |motif,files|
motifs.reverse_each do |motif,files|
  selected = files.select{|f| meta[f]["Xmp.xmpMM.MotifSelected"]}
  ratings = files.collect{|f| meta[f]["Xmp.xmp.Rating"].to_i}
  parent_ids = files.collect{|f| meta[f]["Xmp.xmpMM.DerivedFrom"]}
  ratings.collect!{|r| r ? r : 0}

  if files.size == 1
    `exiv2 -M"del Xmp.xmpMM.MotifID" #{files.first}`
    puts "Motif with single file #{files.first}, MotifID deleted."
  elsif selected.size != 1 or ratings.include? 0
    if files.size == 2 and parent_ids.compact.size == 1 # select original
      i = parent_ids.index nil
      `exiv2 -M"set Xmp.xmpMM.MotifSelected true" #{files[i]}`
      puts "Original file #{files[i]} selected."
    elsif !ratings.include? 0 and ratings.select{|r| r == ratings.max}.size == 1 # select max rating
      #i = ratings.index(ratings.max)
      #`exiv2 -M"set Xmp.xmpMM.MotifSelected true" #{files[i]}`
      #puts "File with max rating #{files[i]} selected."
    elsif ratings.max < 3 and !ratings.include? 0
      puts "=="
      puts "Ignoring deleted files #{files}."
      puts files.collect{|f| meta[f]}.to_yaml
    elsif selected.size == 1
      puts "=="
      puts files.collect{|f| meta[f]}.to_yaml
      ratings.each_with_index do |r,i|
        if r == 0
          puts "Set rating of #{files[i]} to 1"
          `exiv2 -M"set Xmp.xmp.Rating 1" #{files[i]}`
        end
      end
    else
      puts "=="
      rfiles = []
      rfiles = files
      #files.each_with_index do |f,i|
        #rfiles << f if ratings[i] == 0 or ratings[i] > 2 # exclude deleted
      #end
      #files.select!{|f| i = files.index(i); ratings[i] > 2}
      puts "Manual selection from #{rfiles}."
      #puts rfiles.collect{|f| meta[f]}.to_yaml
      #`sxiv -f #{rfiles.join " "}` if rfiles.size > 1
      while (rfiles.size > 1) do
        rfiles.shuffle!
        cand = []
        2.times{ cand << rfiles.shift }
        `sxiv -f #{cand.join " "}` 
        rfiles << File.read("/tmp/selected").chomp
      end
      file = rfiles.first
      rating = `exiv2 -q -P v -g Xmp.xmp.Rating #{file}`.chomp.to_i
      `exiv2 -M"set Xmp.xmp.Rating 3" #{file}` if rating == 0
      `exiv2 -M"set Xmp.xmpMM.MotifSelected true" #{file}`
    end
  end
end
