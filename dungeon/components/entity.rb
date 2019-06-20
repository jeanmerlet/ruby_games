class Entity
  attr_accessor :x, :y
  attr_reader   :char, :color

  def initialize(x, y, character, color)
    @x = x
    @y = y
    @char = character
    @color = BLT.color_from_name(color)
  end
end
