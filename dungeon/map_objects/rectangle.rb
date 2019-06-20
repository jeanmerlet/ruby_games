class Rect
  attr_reader :x1, :y1, :x2, :y2

  def initialize(x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
  end

  def center
    center_x = (@x1 + @x2) / 2
    center_y = (@y1 + @y2) / 2
    [center_x, center_y]
  end

  def intersect?(other)
    @x1 <= other.x2 && @x2 >= other.x1 && @y1 <= other.y2 && @y2 >= other.y1
  end
end
