require_relative 'media.rb'

module Media
  class Video
    include Media
    def thumb
      unless File.exists? @thumb and File.mtime(@thumb) > File.mtime(@path)
        exif = MiniExiftool.new @path
        width, height = thumbsize exif.imagewidth, exif.imageheight
        `ffmpeg -i #{@path} -f image2 -vframes 1 -s #{width}x#{height} #{@thumb}`
      end
      @thumb
    end
    def play
      p @path
      @rotate = "-video-rotate=90"
      pid = spawn "mpv #{@rotate} #{@path} --loop-file"
      Process.detach pid
    end
    def rotate
      @rotate = "-vf rotate=1"
      `gm mogrify -rotate 90 #{@thumb}`
    end
  end
end
