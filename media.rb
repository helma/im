require 'fileutils'
require 'mini_exiftool'

module Media

  attr_reader :path, :tags
  attr_accessor :group
  def initialize path
    @path = File.absolute_path path
    FileUtils.mkdir_p File.join(ENV['HOME'],".cache","am",File.dirname(@path))
    # derived (calculated) metadata in .cache
    @thumb = File.join(ENV['HOME'],".cache","am",@path).sub(File.extname(@path),'.png')
    @fingerprint_file = File.join(ENV['HOME'],".cache","am",@path).sub(File.extname(@path),'.fingerprint')
    @fingerprint = nil
    @tags = []
    @group = nil
    # user created metadata (not recoverable from file) in .local/share
    @json = File.join(ENV['HOME'],".local","share","am",@path).sub(File.extname(@path),'.json')
    if File.exists? @json
      metadata = JSON.load(File.open @json)
      @tags = metadata["tags"]
      @group = metadata["group"]
    end
    @tags << "NEW" if (@tags & ["NEW","DELETE","KEEP","PUBLISH"]).empty?
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
    @tags.delete "KEEP"
    @tags.delete "NEW"
    @tags.delete "PUBLISH"
    save
  end

  def keep
    tag "KEEP"
    @tags.delete "DELETE"
    @tags.delete "NEW"
    save
  end

  def toggle_publish
    if @tags.include? "PUBLISH"
      @tags.delete "PUBLISH"
    else
      tag "KEEP"
      tag "PUBLISH"
      @tags.delete "DELETE"
    end
    save
  end

  def save
    FileUtils.mv @json, @json+"~" if File.exists? @json
    File.open(@json,"w+") do |f|
      metadata = {"tags" => @tags, "group" => @group}
      f.puts metadata.to_json
    end
    #puts `trash #{@path} #{thumb}` if @tags.include? "DELETE"
  end
end
