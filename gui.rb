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
    add_widget Info.new(@model)
    setCurrentIndex 0
    show
  end

  def tag_input
    `echo '#{(@model.tags.collect{|t| @model.current.tags.include?(t) ?  "+#{t}" : t.to_s}.sort).join("\n")}' | dmenu -b `.chomp.sub(/\+/, '')
  end

  def quit
    `chuck --kill`
    Qt::Application.quit
  end

  def keyPressEvent event
    case event.text
    when "q"
      quit
    when "l"
      @model.move 1
    when "h"
      @model.move -1
    when "0"
      @model.move -@model.current_idx
    when "$"
      @model.move @model.size-@model.current_idx-1
    when "G"
      @model.tag = @model.current.group
    when "s"
      @model.save
    when "i"
      setCurrentIndex 1
    when "t"
      @model.current.toggle_tag tag_input
    else
      case event.key
      when Qt::Key_Left
        @model.move -1
      when Qt::Key_Right
        @model.move 1
      when Qt::Key_Home
        @model.move -@model.current_idx
      when Qt::Key_End
        @model.move @model.size-1
      when Qt::Key_Backspace
        @model.current.toggle_tag "DELETE"
      when Qt::Key_Escape
        setCurrentIndex 0
        @model.tag = nil
      when Qt::Key_Slash
        @model.tag = tag_input
      else
        current_widget.keyPressEvent event
      end
    end
    @model.sort!
    current_widget.redraw
  end

end
