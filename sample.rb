require 'waveform'
require_relative 'media.rb'

module Media
  class Sample
    include Media
    def thumb
      unless File.exists? @thumb and File.mtime(@thumb) > File.mtime(@path)
        width, height = thumbsize 4, 3
        Waveform.generate @path, @thumb, :width => width, :height => height, :force => true
      end
      @thumb
    end
    def play
      #Process.kill "HUP", $mpv_pid if $mpv_pid
      #$mpv_pid = spawn "mpv --gapless-audio=yes #{@rotate} #{@path} --loop-file"
      #Process.detach $mpv_pid
      unless $mplayer_pid
        `mkfifo /tmp/mplayer`
        $mplayer_pid = spawn "mplayer -idle -slave -input file=/tmp/mplayer '#{@path}' -loop 0"
        Process.detach $mplayer_pid
      end
      #`echo "loop 0" > /tmp/mplayer`
      `echo "loadfile '#{@path}'" > /tmp/mplayer`
      #`echo "run" > /tmp/mplayer`
    end

    def quit
    end
  end
end
