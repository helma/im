require 'Qt'
require_relative "index.rb"
require_relative "show.rb"

class Gui < Qt::StackedWidget

  def initialize model
    super nil
    @model = model
    add_widget Index.new(@model)
    add_widget Show.new(@model)
    setStyleSheet("background-color: black")
    setCurrentIndex 0
    show
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
      @model[@model.current_idx].keep
      @model.images.delete_at @model.current_idx
    elsif k == Qt::Key_Delete
      @model[@model.current_idx].delete
      @model.images.delete_at @model.current_idx
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
