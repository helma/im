require 'Qt'
require_relative "image.rb"
require_relative "view.rb"
require_relative "index.rb"

class Gui < Qt::StackedWidget

  def initialize media
    super nil
    @media = media
    add_widget View.new(@media)
    add_widget Index.new(@media)
    setCurrentIndex 1
    show
  end

  def keyPressEvent event
    case event.text
    when "q"
      Qt::Application.quit
    when "l"
      @media.move 1
    when "h"
      @media.move -1
    when "g"
      @media.move -@media.current
    when "G"
      @media.move @media.size-@media.current-1
    else
      case event.key
      when Qt::Key_Left
        @media.move -1
      when Qt::Key_Right
        @media.move 1
      when Qt::Key_Home
        @media.move -@media.current
      when Qt::Key_End
        @media.move @media.size-1
      when Qt::Key_Backspace
        @media.delete_at @media.current
      when Qt::Key_Escape
        setCurrentIndex 1
      when Qt::Key_Return
        setCurrentIndex 0
      else
        current_widget.keyPressEvent event
      end
    end
    current_widget.redraw
  end

end
