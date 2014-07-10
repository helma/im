class Image < Qt::Label

  def initialize
    super
    set_alignment Qt::AlignCenter
    border "white"
    bg "white"
  end

  def border color
    setStyleSheet "border: 1px solid #{color}"
  end

  def bg color
    setStyleSheet "background-color: #{color}"
  end
end

