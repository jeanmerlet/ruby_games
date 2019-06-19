class Rect
  attr_reader :x1, :y1, :x2, :y2

  def initialize(x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
  end
end
