require 'base64'
require 'fileutils'

class Image

  attr_accessor :meta

  def initialize metadata
    @meta = metadata
  end

  def file
    @meta["SourceFile"]
  end

  def thumb
    @thumb = File.join(ENV['HOME'],".cache","am",file)
    FileUtils.mkdir_p File.dirname @thumb
    unless File.exists? @thumb and File.mtime(@thumb) > File.mtime(file)
      File.open(@thumb,"w+"){|f| f.print Base64.decode64 @meta["ThumbnailImage"].sub('base64:','')}
    end
    @thumb
  end

  def delete
    #@meta["Rating"] == 1
    `exiftool -Rating=1 #{file}`
  end

  def keep
    #@meta["Rating"] == 3
    `exiftool -Rating=3 #{file}`
  end

  def publish
    @meta["Rating"] == 5
  end

  def width
    @meta["ImageWidth"]
  end

  def height
    @meta["ImageHeight"]
  end

  def tags
    @meta["Subject"]
  end

  def rating
    @meta["Rating"].to_i
  end

  def group
    @meta["Group"]
  end
end
