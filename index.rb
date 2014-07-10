class Index < Qt::Widget

  def initialize media, rows=6, cols=8

    super nil

    @rows = rows
    @cols = cols

    @media = media

    @layout = Qt::GridLayout.new
    @layout.contents_margins = Qt::Margins.new(0,0,0,0)
    @layout.horizontal_spacing = 0
    @layout.vertical_spacing = 0

    @rows.times do |row|
      @cols.times do |col|
        @layout.add_widget Label.new, row, col
      end
    end
    setStyleSheet "background-color: white"
    set_layout @layout
    redraw
  end

  def redraw
    set_layout @layout
    w = 1280/@cols
    h = 800/@rows
    n = @media.current_idx - @media.current_idx % (@rows*@cols)
    n = 0 if n < 0
    @rows.times do |row|
      @cols.times do |col|
        label = @layout.itemAtPosition(row,col).widget
        if @media[n]
          thumb = @media[n].thumb
          label.pixmap = Qt::Pixmap.new(thumb).scaled(w,h,Qt::KeepAspectRatio,Qt::SmoothTransformation)
        else
          label.pixmap = Qt::Pixmap.new w,h
          label.pixmap.fill
        end
        label.border "white"
        label.border "blue" if n == @media.current_idx
        n += 1
      end
    end
  end

  def keyPressEvent event
    case event.text
    when "k"
      @media.move -@cols
    when "j"
      @media.move @cols
    when " "
      @media.move @rows*@cols
    when "b"
      @media.move -@rows*@cols
    else
      case event.key
      when Qt::Key_Down
        @media.move @cols
      when Qt::Key_Up
        @media.move -@cols
      when Qt::Key_PageUp
        @media.move -@rows*@cols
      when Qt::Key_PageDown
        @media.move @rows*@cols
      end
    end
    redraw
  end

end

