require_relative 'image.rb'
require_relative 'sample.rb'
require_relative 'video.rb'

class Model < Array

  attr_reader :current_idx
  attr_accessor :group

  def initialize objects
    super objects
    @group = nil
    @delete = []
    @current_idx = 0
    sort!
  end

  def Model.from_dir args
    dir = args.shift
    tag = args.shift
    objects = []
    extensions = {
      Media::Image => ["jpg","jpeg","png","gif"],
      Media::Sample => ["wav","aif","aiff"],
      Media::Video => ["MOV","avi","mp4"]
    }
    extensions.each do |klass,ext|
      ext.each do |e|
        Dir.glob(File.join(dir,"**","*"+e), File::FNM_CASEFOLD).compact.each do |f|

          unless f.match(/chain|matrix/)
            o = klass.new(f)
            if tag
              objects << o if o.tags.include? tag
            else
              objects << o
            end
          end
        end
      end
    end
    Model.new objects
  end

  def group_move i
    group = current_group
    group_idx = group.index self.current
    group_idx = (group_idx+i) % group.size 
    @current_idx = index group[group_idx]
  end

  def move i, group=false
    #if group and @group 
    if group 
      group_move(i) 
    else
      @current_idx = (@current_idx+i) % size
    end
  end

  def current
    self[@current_idx]
  end

  def current_group
    Model.new select{|m| m.group == @group}
  end

  def save
    each { |o| o.save }
    select{ |o| o.tags.include? "DELETE"}.each{|o| delete o}
  end

  def sort!
    sort_by!{|m| m.path}
    sorted = []
    until self.empty? 
      o = shift
      sorted << o
      if o.group
        select{|m| m.group == o.group}.each do |m|
          sorted << delete(m)
        end
      end
    end
    initialize_copy sorted
  end

  def simsort!
    thresh = 0.7
    clusters = []
    until empty?
      group = []
      group << shift
      each do |o|
        sim = group.first % o
        group << delete(o) if sim > thresh
      end
      clusters << group
    end
    clusters.flatten!
    initialize_copy clusters#.first
  end

end
