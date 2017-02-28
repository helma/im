require 'Qt'
require_relative "label.rb"
require_relative "index.rb"
require_relative "show.rb"

class Gui < Qt::StackedWidget

  def initialize model
    super nil
    @model = model
    add_widget Index.new(@model)
    add_widget Show.new(@model)
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
    k = event.key
    t = event.text
    if k == Qt::Key_Left or k == Qt::Key_H
      @model.move -1
    elsif k == Qt::Key_Right or k == Qt::Key_L
      @model.move 1
    elsif k == Qt::Key_Home or t == "g"
      @model.move -@model.current_idx
    elsif k == Qt::Key_End or t == "G"
      @model.move @model.size-@model.current_idx-1
    elsif k == Qt::Key_Insert
        p "insert"
    elsif k == Qt::Key_Delete
        p "delete"
    elsif k == Qt::Key_Return
      setCurrentIndex 1
    elsif k == Qt::Key_Escape
      setCurrentIndex 0
    elsif k == Qt::Key_Q
      Qt::Application.quit
    else
      current_widget.keyPressEvent event
    end
    current_widget.redraw
  end

end
