class Show < Label

  def initialize model
    super()
    @model = model
    redraw
  end

  def redraw
    setStyleSheet("background-color: black")
    self.pixmap = Qt::Pixmap.new(@model.current.file).scaled(1920,1080,Qt::KeepAspectRatio,Qt::SmoothTransformation) 
  end

  def keyPressEvent event
    k = event.key
    if k == Qt::Key_Up or k == Qt::Key_K or k == Qt::Key_PageUp or k == Qt::Key_B
      @model.move -1
    elsif k == Qt::Key_Down or k == Qt::Key_J or k == Qt::Key_PageDown or k == Qt::Key_Space
      @model.move 1
    end
  end

end

