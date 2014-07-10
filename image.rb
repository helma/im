require_relative 'media.rb'

module Media
  class Image
    include Media
    def thumb
      unless File.exists? @thumb and File.mtime(@thumb) > File.mtime(@path)
        exif = MiniExiftool.new @path
        width, height = thumbsize exif.imagewidth, exif.imageheight
        `gm convert "#{@path}" -thumbnail #{width}x#{height} -strip "#{@thumb}"`
      end
      @thumb
    end
  end
end
