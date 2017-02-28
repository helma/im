require 'securerandom'
class Index < Qt::Widget

  def initialize model, rows=6, cols=7

    super nil

    @rows = rows
    @cols = cols

    @model = model

    @layout = Qt::GridLayout.new
    @layout.contents_margins = Qt::Margins.new(0,0,0,0)
    @layout.horizontal_spacing = 0
    @layout.vertical_spacing = 0

    @rows.times do |row|
      @cols.times do |col|
        @layout.add_widget Label.new, row, col
      end
    end
    setStyleSheet("background-color: black")
    set_layout @layout
    redraw
  end

  def redraw
    #@model.group ?  setStyleSheet("background-color: yellow") : setStyleSheet("background-color: lightgrey")
    w = 1920/@cols
    h = 1080/@rows
    n = @model.current_idx - @model.current_idx % (@rows*@cols)
    n = 0 if n < 0
    setStyleSheet("background-color: black")
    @rows.times do |row|
      @cols.times do |col|
        label = @layout.itemAtPosition(row,col).widget
        if @model[n]
          thumb = @model[n].thumb
          label.pixmap = Qt::Pixmap.new(@model[n].thumb).scaled(w,h,Qt::KeepAspectRatio,Qt::SmoothTransformation)
        else
          label.pixmap = Qt::Pixmap.new w,h
          label.pixmap.fill
        end
        label.border "black"
        #label.border "white"
        #label.border "red" if @model[n] and @model[n].tags.include? "DELETE"
        #label.border "black" if @model[n] and (@model[n].tags & ["KEEP","DELETE"]).empty? and !@model.group
        label.border "yellow" if @model[n] and @model[n].group and @model.current and @model[n].group == @model.current.group
        #label.bg "white" if @model[n] and @model[n].tags.include? "PUBLISH"
        label.bg "yellow" if @model[n] and @model[n].group and @model[n].group == @model.current.group
        label.border "white" if n == @model.current_idx
        n += 1
      end
    end
  end

  def keyPressEvent event
    k = event.key
    if k == Qt::Key_Up or k == Qt::Key_K
      @model.move -@cols
    elsif k == Qt::Key_Down or k == Qt::Key_J
      @model.move @cols
    elsif k == Qt::Key_PageDown or k == Qt::Key_Space
      @model.move @rows*@cols
    elsif k == Qt::Key_PageUp or k == Qt::Key_B
      @model.move -@rows*@cols
    end
  end

end

