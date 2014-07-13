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
    setStyleSheet("background-color: white")
    set_layout @layout
    redraw
  end

  def redraw
    @model.group ?  setStyleSheet("background-color: yellow") : setStyleSheet("background-color: lightgrey")
    w = 1280/@cols
    h = 800/@rows
    n = @model.current_idx - @model.current_idx % (@rows*@cols)
    n = 0 if n < 0
    @rows.times do |row|
      @cols.times do |col|
        label = @layout.itemAtPosition(row,col).widget
        if @model[n]
          thumb = @model[n].thumb
          label.pixmap = Qt::Pixmap.new(thumb).scaled(w,h,Qt::KeepAspectRatio,Qt::SmoothTransformation)
        else
          label.pixmap = Qt::Pixmap.new w,h
          label.pixmap.fill
        end
        label.border "white"
        label.border "red" if @model[n] and @model[n].tags.include? "DELETE"
        label.border "black" if @model[n] and (@model[n].tags & ["KEEP","DELETE"]).empty? and !@model.group
        label.border "yellow" if @model[n] and @model[n].group and @model[n].group == @model.current.group
        label.bg "white" if @model[n] and @model[n].tags.include? "PUBLISH"
        label.bg "yellow" if @model[n] and @model[n].group and @model[n].group == @model.current.group
        label.bg "black" if n == @model.current_idx
        n += 1
      end
    end
  end

  def keyPressEvent event
    case event.text
    when "k"
      @model.move -@cols
    when "j"
      @model.move @cols
    when " "
      @model.move @rows*@cols
    when "b"
      @model.move -@rows*@cols
    when "g"
      if @model.group 
        @model.current.group = @model.group
        @model.move 1
      else
        @model.group = @model.current.group 
        @model.group ||= SecureRandom.uuid
      end
    else
      case event.key
      when Qt::Key_Down
        @model.move @cols
      when Qt::Key_Up
        @model.move -@cols
      when Qt::Key_PageUp
        @model.move -@rows*@cols
      when Qt::Key_PageDown
        @model.move @rows*@cols
      end
    end
    redraw
  end

end

