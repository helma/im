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
    else
      case event.key
      when Qt::Key_Return
        @model.current.toggle_tag "KEEP"
      end
    end
  end
end

