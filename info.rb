class Info < Qt::ScrollArea

  def initialize model
    super()
    @model = model
    @label = Label.new
    @label.set_alignment Qt::AlignLeft
    @label.setStyleSheet "font: 14pt Monospace"
    setWidgetResizable true
    setWidget @label
    redraw
  end

  def redraw
    @label.text = "#{@model.tag}\n#{@model.current.info}"
  end

end

