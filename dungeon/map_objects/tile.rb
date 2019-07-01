class Tile
  attr_accessor :blocked, :explored, :bevel_nw, :bevel_ne, :bevel_se, :bevel_sw

  def initialize(blocked)
    @blocked = blocked
    @explored = false
    @beveled_nw = false
    @beveled_ne = false
    @beveled_se = false
    @beveled_sw = false
  end
end

class PathingTile
  attr_reader :x, :y, :g, :h, :parent

  def initialize(x, y, g, h, parent = nil, children = nil)
    @x, @y = x, y
    @g, @h = g, h
    @f = @g + @h
    @parent = parent
    @children = children
  end
end
