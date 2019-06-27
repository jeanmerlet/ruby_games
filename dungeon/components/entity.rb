class Entity
  attr_accessor :x, :y, :fov_id, :blocks
  attr_reader   :char, :color, :name

  def initialize(x, y, character, color, name, blocks = true)
    @x = x
    @y = y
    @char = character
    @color = BLT.color_from_name(color)
    @name = name
    @blocks = blocks
    @fov_id = 1
  end
end
