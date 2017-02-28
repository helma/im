require 'fileutils'
require 'mini_exiftool'

class String
  def uuid?
    self.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i)
  end
end

module Media

  REVIEW_TAGS = ["NEW","DELETE","KEEP"]
  attr_reader :path, :tags, :group

  def initialize path
    @path = File.absolute_path path
    FileUtils.mkdir_p File.join(ENV['HOME'],".cache","am",File.dirname(@path))
    # derived (calculated) metadata in .cache
    @thumb = File.join(ENV['HOME'],".cache","am",@path).sub(File.extname(@path),'.png')
    # user created metadata (not recoverable from file) in .local/share
    @tags = []
    @json = File.join(ENV['HOME'],".local","share","am",@path).sub(File.extname(@path),'.json')
    if File.exists? @json
      @tags = JSON.load(File.open @json).collect{|t| t.to_s}
      update_group
    end
    @tags << "NEW" if (@tags & REVIEW_TAGS).empty?
  end

  def update_group
    groups = @tags.select{|t| t.to_s.uuid?}
    groups.empty? ? @group=nil : @group=groups.first
  end

  def group= uuid
    tag uuid
  end

  def toggle_tag t
    @tags.include?(t) ? untag(t) : tag(t)
  end

  def tag t
    @tags -= REVIEW_TAGS if REVIEW_TAGS.include? t
    @tags.delete_if{|t| uuid? t} if t.uuid?
    @tags << t
    @tags.uniq!
    update_group if t.uuid?
    save
  end

  def untag t
    @tags.delete t
    @tags << "NEW" if (@tags & REVIEW_TAGS).empty?
    update_group if t.uuid?
    save
  end

  def save
    FileUtils.mkdir_p File.dirname(@json)
    FileUtils.cp @json, @json+"~" if File.exists? @json
    File.open(@json,"w+") { |f| f.puts @tags.uniq.compact.to_json }
  end

end
