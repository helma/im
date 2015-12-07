#require 'waveform'
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
      #if $chuck_pid 
        #$chuck_pid = spawn "chuck --loop"
        #Process.detach $chuck_pid
        #`chuck + #{File.join(File.dirname(__FILE__),"player.ck")}:#{@path}`
      #else
        `chuck = 1 #{File.join(File.dirname(__FILE__),"player.ck")}:#{@path}`
      #end
    end

    def info
      `soxi #{path}`
    end

    def quit
    end
  end
end
