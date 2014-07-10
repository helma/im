class View < Image

  def initialize media
    super()
    @media = media
    redraw
  end

  def redraw
    self.pixmap = Qt::Pixmap.new @media[@media.current].path
  end

  def keyPressEvent event
    case event.text
    when " "
      @media.move 1
    when "b"
      @media.move -1
    end
  end
end

