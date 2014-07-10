class View < Label

  def initialize media
    super()
    @media = media
    redraw
  end

  def redraw
    self.pixmap = Qt::Pixmap.new(@media.current_file).scaled(1280,800,Qt::KeepAspectRatio,Qt::SmoothTransformation) if @media.current.is_a? Media::Image
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

