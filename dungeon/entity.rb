class Entity
  attr_reader :x, :y, :char, :color

  def initialize(x, y, character, color)
    @x = x
    @y = y
    @char = character
    @color = BLT.color_from_name(color)
  end

  def move(dx, dy)
    @x += dx
    @y += dy
  end

  def draw
    BLT.print(@x, @y, "[color=#{@color}][#{@char}]")
  end

  def clear
    BLT.print(@x, @y, " ")
  end
end
