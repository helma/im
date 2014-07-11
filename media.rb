require 'fileutils'
require 'mini_exiftool'

module Media

  attr_reader :path, :tags
  def initialize path
    @path = File.absolute_path path
    FileUtils.mkdir_p File.join(ENV['HOME'],".cache","am",File.dirname(@path))
    @thumb = File.join(ENV['HOME'],".cache","am",@path).sub(File.extname(@path),'.png')
    @tags = []
  end

  def thumbsize w,h
    height = 100
    width = 16*height/9
    ratio = [width/w.to_f, height/h.to_f].min
    [(w*ratio).round, (h*ratio).round]
  end

  def tag t
    @tags << t
    @tags.uniq!
  end

  def delete
    tag "DELETE"
  end

  def save
    puts `trash #{@path} #{thumb}` if @tags.include? "DELETE"
  end
end
