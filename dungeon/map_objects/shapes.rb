class Rect
  attr_reader :x1, :y1, :x2, :y2, :center

  def initialize(x, y, w, h)
    @x1 = x
    @y1 = y
    @x2 = x + w
    @y2 = y + h
    @center = find_center
  end

  def find_center
    center_x = (@x1 + @x2) / 2
    center_y = (@y1 + @y2) / 2
    [center_x, center_y]
  end

  def intersect?(rect)
    @x1 <= rect.x2 && @x2 >= rect.x1 && @y1 <= rect.y2 && @y2 >= rect.y1
  end
end

class Circle
  attr_reader :x, :y, :r, :center

  def initialize(x, y, r)
    @x = x
    @y = y
    @r = r
    @center = [@x, @y]
  end

  def intersect?(circle)
    x = @x - circle.x
    y = @y - circle.y
    r = @r + circle.r + 1
    x*x + y*y < r*r
  end
end
