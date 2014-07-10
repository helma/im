class Index < Qt::Widget

  def initialize media, rows=6, cols=8

    super nil

    @rows = rows
    @cols = cols

    @media = media
    #@pixmaps = {}
    @labels = []

    @layout = Qt::GridLayout.new
    @layout.contents_margins = Qt::Margins.new(0,0,0,0)
    @layout.horizontal_spacing = 0
    @layout.vertical_spacing = 0

    @rows.times do |row|
      @labels[row] = []
      @cols.times do |col|
        label = Image.new
        @labels[row][col] = label
        file = @media[row*@cols+col].path
        label.pixmap = Qt::Pixmap.new(file).scaled(1280/@cols,800/@rows,Qt::KeepAspectRatio,Qt::SmoothTransformation)
        label.border "black" if row*@cols+col == @media.current
        @layout.add_widget label, row, col
      end
    end
    setStyleSheet "background-color: white"
    set_layout @layout
  end

  def redraw
    set_layout @layout
    n = @media.current - @media.current % (@rows*@cols)
    n = 0 if n < 0
    @rows.times do |row|
      @cols.times do |col|
        label = @labels[row][col]
        if @media[n]
          file = @media[n].path
          label.pixmap = Qt::Pixmap.new(file).scaled(1280/@cols,800/@rows,Qt::KeepAspectRatio,Qt::SmoothTransformation)
        else
          label.pixmap = Qt::Pixmap.new label.pixmap.width, label.pixmap.height
          label.pixmap.fill
        end
        label.border "white"
        label.border "black" if n == @media.current
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

