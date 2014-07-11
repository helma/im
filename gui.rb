require 'Qt'
require_relative "label.rb"
require_relative "view.rb"
require_relative "index.rb"

class Gui < Qt::StackedWidget

  def initialize media
    super nil
    @media = media
    #add_widget Info.new(@media)
    add_widget View.new(@media)
    add_widget Index.new(@media)
    setCurrentIndex 1
    show
  end

  def save
  end

  def quit
    `echo "quit" > /tmp/mplayer` if File.exists? "/tmp/mplayer"
    #Process.kill "HUP", $mplayer_pid if $mplayer_pid
    `killall mpv`
    Qt::Application.quit
  end

  def keyPressEvent event
    case event.text
    when "q"
      quit
    when "l"
      @media.move 1
    when "h"
      @media.move -1
    when "g"
      @media.move -@media.current_idx
    when "G"
      @media.move @media.size-@media.current_idx-1
    when "r"
      @media.current.rotate
    when "s"
      @media.save
    else
      case event.key
      when Qt::Key_Left
        @media.move -1
      when Qt::Key_Right
        @media.move 1
      when Qt::Key_Home
        @media.move -@media.current_idx
      when Qt::Key_End
        @media.move @media.size-1
      when Qt::Key_Backspace
        @media.current.delete
        @media.move 1
      when Qt::Key_Escape
        setCurrentIndex 1
      when Qt::Key_Return
        @media.current.is_a?(Media::Image) ? setCurrentIndex(0) : @media.current.play
      else
        current_widget.keyPressEvent event
      end
    end
    current_widget.redraw
  end

end
