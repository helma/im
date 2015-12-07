class Group < Qt::Widget
  def initialize model
    super nil
    @model = model
    @layout = Qt::GridLayout.new
    @layout.contents_margins = Qt::Margins.new(0,0,0,0)
    @layout.horizontal_spacing = 0
    @layout.vertical_spacing = 0
    set_layout @layout
  end

  def redraw

    (0..@layout.count).each do |i|
      item = @layout.item_at i
      @layout.remove_item item
      item.widget.pixmap = Qt::Pixmap.new if item
      #@layout.remove_widget(@layout.item_at(i).widget) if @layout.item_at(i)
    end

    group = @model.current_group
    i = Math.sqrt(group.size)
    w = 1280/i
    h = 800/i
    n = 0

    i.floor.times do |row|
      i.ceil.times do |col|
        label = Label.new
        @layout.add_widget label, row, col
        if group[n]
          file = group[n].path
          label.pixmap = Qt::Pixmap.new(file).scaled(w,h,Qt::KeepAspectRatio,Qt::SmoothTransformation)
          label.border "red" if group[n].tags.include? "DELETE"
          label.border "green" if group[n].tags.include? "KEEP"
          label.border "black" if group[n] == @model.current
        else
          label.pixmap = Qt::Pixmap.new w,h
          label.pixmap.fill
        end
        n+=1
      end
    end
    setStyleSheet("background-color: white")
  end
end
