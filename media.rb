require 'fileutils'
require 'mini_exiftool'

module Media

  attr_accessor :path
  def initialize path
    @path = File.absolute_path path
    FileUtils.mkdir_p File.join(ENV['HOME'],".cache","am",File.dirname(@path))
    @thumb = File.join(ENV['HOME'],".cache","am",@path).sub(File.extname(@path),'.png')
  end

  def thumbsize w,h
    height = 100
    width = 16*height/9
    ratio = [width/w.to_f, height/h.to_f].min
    [(w*ratio).round, (h*ratio).round]
  end
end
