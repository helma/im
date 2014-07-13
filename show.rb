class Show < Label

  def initialize model
    super()
    @model = model
    redraw
  end

  def redraw
    self.pixmap = Qt::Pixmap.new(@model.current.path).scaled(1280,800,Qt::KeepAspectRatio,Qt::SmoothTransformation) if @model.current.is_a? Media::Image
  end

  def keyPressEvent event
    case event.text
    when " "
      @model.move 1
    when "b"
      @model.move -1
    end
  end
end

