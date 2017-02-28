require 'json'
require_relative 'image.rb'

class Model

  attr_reader :current_idx, :group, :tag# :selection, :tags

  def initialize files
    @images = JSON.parse(`exiftool -j -b #{files.collect{|f| "'#{f}'"}.join " "}`).collect{|meta| Image.new meta}
    @current_idx = 0
  end

  def filter property, value
    @images.select!{|i| i.meta[property] == value}
  end

  def sort property
    @images.sort_by!{|i| i.meta[property]}
  end

  def group_move i
    group_idx = current_group.index self.current
    group_idx = (group_idx+i) % current_group.size 
    @current_idx = @images.index current_group[group_idx]
  end

  def [](n)
    @images[n]
  end

  def move i
    @current_idx = (@current_idx+i) % @images.size
  end

  def current
    @images[@current_idx]
  end

  def current_group
    @images.select{|i| i.group == current.group}
  end

  def save
    @images.each {|i| i.save }
  end

  def size
    @images.size
  end

  def tags
    @images.collect{|i| i.tags}.flatten.uniq.compact
  end

  #def group= t
    #tag = t
  #end

  def tag= tag
    @tag = tag
    update!
  end

  def update!
    oi = images.index current
    @tag ?  @images = images.select{|o| o.tags.include? @tag} : @images = images.clone
    sort!
    if @images.include? images[oi]
      @current_idx = @images.index images[oi]
    else
      cand = images[oi]
      i = 1
      until @images.include? cand
        p (oi+i) % images.size
        cand = images[oi+i]
        break if @images.include? cand
        p (oi-i)
        cand = images[oi-i]
        break if @images.include? cand
        i+=1
      end
      @current_idx = @images.index cand
    end
  end

end
