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

class Circle
  attr_reader :x, :y, :r, :midpoint

  def initialize(x, y, r)
    @x = x
    @y = y
    @r = r
    @midpoint = ((r-0.5) / Math.sqrt(2)).round
    print "r: #{@r} m: #{@midpoint}\n"
    @border = initialize_border
  end

  def initialize_border
    border = [[@r, 0], [@x/2, @y/2]]
    x, y = @x + @r, @y
    while x > (@x/2) && y < (@y/2)
      y -= 1
      if true
      end
    end
  end

  def center
    [x, y]
  end

  def contains?(x, y)
  end
end

10.times { |i| Circle.new(0, 0, i+1) }
