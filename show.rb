class Show < Qt::Label

  def initialize model
    super()
    set_alignment Qt::AlignCenter
    @model = model
    setStyleSheet("background-color: black")
    redraw
  end

  def redraw
    p (@model.current.file)
    i = Qt::Pixmap.new(@model.current.file)
    self.pixmap = i.scaled(1920,1080,Qt::KeepAspectRatio,Qt::SmoothTransformation) 
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

