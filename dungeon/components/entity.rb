class Entity
  attr_accessor :x, :y, :blocks, :fov_id
  attr_reader   :char, :color, :name

  def initialize(x, y, character, color, name, blocks = true, fov_id = 1)
    @x = x
    @y = y
    @char = character
    @color = BLT.color_from_name(color)
    @name = name
    @blocks = blocks
    @fov_id = fov_id
  end
end
