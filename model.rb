require_relative 'image.rb'
require_relative 'sample.rb'
require_relative 'video.rb'

class Model < Array

  attr_reader :current_idx
  def initialize args
    super []
    @dir = args.shift
    @tags = args
    objects = []
    extensions = {
      Media::Image => ["jpg","jpeg","png","gif"],
      Media::Sample => ["wav","aif","aiff"],
      Media::Video => ["MOV","avi","mp4"]
    }
    extensions.each do |klass,ext|
      ext.each do |e|
        Dir.glob(File.join(@dir,"**","*"+e), File::FNM_CASEFOLD).compact.each do |f|
          objects << klass.new(f) unless f.match(/chain|matrix/)
        end
      end
    end
    super objects
    @current_idx = 0
    sort_by!{|m| File.mtime m.path}
  end

  def move i
    @current_idx = (@current_idx+i) % size if i
  end

  def current
    self[@current_idx]
  end

  def current_file
    current.path
  end
end
