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
    @meta["Rating"]
  end

  def group
    @meta["Group"]
  end
end
