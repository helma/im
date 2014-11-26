require_relative 'image.rb'
require_relative 'sample.rb'
require_relative 'video.rb'

class Model

  attr_reader :current_idx, :group, :tag# :selection, :tags

  def initialize objects, tag=nil
    objects.sort_by!{|m| m.path}
    @objects = []
    until objects.empty? 
      o = objects.shift
      @objects << o
      if o.group
        objects.select{|m| m.group == o.group}.each do |m|
          @objects << objects.delete(m)
        end
      end
    end
    @tag = tag
    @tag ?  @selection = @objects.select{|o| o.tags.include? @tag} : @selection = @objects.clone
    @current_idx = 0
    update!
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

          objects << klass.new(f) unless f.match(/chain|matrix/)
        end
      end
    end
    Model.new objects, tag
  end

  def group_move i
    group_idx = current_group.index self.current
    group_idx = (group_idx+i) % current_group.size 
    @current_idx = @selection.index current_group[group_idx]
  end

  def [](n)
    @selection[n]
  end

  def move i
    @current_idx = (@current_idx+i) % @selection.size
  end

  def current
    @selection[@current_idx]
  end

  def current_group
    @group ||= current.group
    @objects.select{|m| m.group == @group}
  end

  def save
    @selection.each { |o| o.save }
  end

  def size
    @selection.size
  end

  def tags
    @objects.collect{|o| o.tags}.flatten.uniq.select{|t| !t.uuid?}.compact
  end

  #def group= t
    #tag = t
  #end

  def tag= tag
    @tag = tag
    update!
  end

  def update!
    oi = @objects.index current
    @tag ?  @selection = @objects.select{|o| o.tags.include? @tag} : @selection = @objects.clone
    sort!
    if @selection.include? @objects[oi]
      @current_idx = @selection.index @objects[oi]
    else
      cand = @objects[oi]
      i = 1
      until @selection.include? cand
        p (oi+i) % @objects.size
        cand = @objects[oi+i]
        break if @selection.include? cand
        p (oi-i)
        cand = @objects[oi-i]
        break if @selection.include? cand
        i+=1
      end
      @current_idx = @selection.index cand
    end
  end

  def sort!
    @selection.sort_by!{|m| m.path}
    sorted = []
    until @selection.empty? 
      o = @selection.shift
      sorted << o
      if o.group
        @selection.select{|m| m.group == o.group}.each do |m|
          sorted << @selection.delete(m)
        end
      end
    end
    @selection = sorted
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
