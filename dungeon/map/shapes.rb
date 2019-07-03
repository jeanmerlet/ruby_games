class Rect
  attr_reader :x1, :y1, :x2, :y2, :center

  def initialize(x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
    @center = [(@x1 + @x2)/2, (@y1 + @y2)/2]
  end
end

class Circ
  attr_reader :x, :y, :r, :center

  def initialize(x, y, r)
    @x = x
    @y = y
    @r = r
    @center = [@x, @y]
  end
end
