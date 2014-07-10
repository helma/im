require_relative 'media.rb'

class Model < Array

  attr_accessor :current
  def initialize args
    @dir = args.shift
    @tags = args
    files = []
    ["jpg","jpeg","png","gif","wav","aif","aiff","MOV","avi","mp4"].each do |ext|
      files += Dir.glob(File.join(@dir,"**","*"+ext), File::FNM_CASEFOLD)
    end
    super files.compact.sort.collect{|f| Media.new f}
    @current = 0
  end

  def move i
    @current = (@current+i) % size if i
  end
end
