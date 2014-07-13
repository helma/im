require 'Qt'
require_relative "label.rb"
require_relative "index.rb"
require_relative "show.rb"
require_relative "info.rb"

class Gui < Qt::StackedWidget

  def initialize model
    super nil
    @model = model
    add_widget Index.new(@model)
    add_widget Show.new(@model)
    add_widget Info.new(@model)
    setCurrentIndex 0
    show
  end

  def quit
    `echo "quit" > /tmp/mplayer` if File.exists? "/tmp/mplayer"
    `killall mpv`
    Qt::Application.quit
  end

  def keyPressEvent event
    current_index == 0 ? group_move = false : group_move = true
    #p group_move
    case event.text
    when "q"
      quit
    when "l"
      @model.move 1, group_move
    when "h"
      @model.move -1, group_move
    when "0"
      @model.move -@model.current_idx, group_move
    when "G"
      @model.move @model.size-@model.current_idx-1, group_move
    when "r"
      @model.current.rotate
    when "s"
      @model.save
    when "i"
        setCurrentIndex 2
    when "\\"
      @model.current.toggle_publish
    when "v"
      @model.current.is_a?(Media::Image) ? setCurrentIndex(1) : @model.current.play
    else
      case event.key
      when Qt::Key_Left
        @model.move -1, group_move
      when Qt::Key_Right
        @model.move 1, group_move
      when Qt::Key_Home
        @model.move -@model.current_idx, group_move
      when Qt::Key_End
        @model.move @model.size-1, group_move
      when Qt::Key_Backspace
        @model.current.delete
        #@model.move 1, group_move
      when Qt::Key_Escape
        setCurrentIndex 0
        @model.group = nil
      when Qt::Key_Return
        @model.current.keep
      else
        current_widget.keyPressEvent event
      end
    end
    current_widget.redraw
  end

end
