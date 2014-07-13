require_relative 'media.rb'
require 'phash/image'

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

    def fingerprint
      if File.exists? @fingerprint_file and File.mtime(@fingerprint_file) > File.mtime(@path)
        p "loading fp"
        @fingerprint ||= Marshal.load(File.read @fingerprint_file)
      else
        p "calculating fp"
        @fingerprint = Phash::Image.new @thumb
        File.open(@fingerprint_file,"w+"){|f| f.print Marshal.dump(@fingerprint)}
      end
      @fingerprint
    end

    def % img
      fingerprint % img.fingerprint
    end

    def info
      info = "Tags                            : #{@tags.join ", "}\n"
      info += "Group                           : #{@group}\n"
      info + `exiftool #{@path}`
    end
  end
end
