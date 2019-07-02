class Entity
  attr_accessor :x, :y, :blocks, :fov_id, :fighter, :ai
  attr_reader   :char, :color, :name

  def initialize(x, y, char, name, color, blocks = true)
    @x, @y, @char, @name = x, y, char, name
    @color = BLT.color_from_name(color)
    @blocks = true
    @fov_id = 1
    @fighter = nil
    @ai = nil
  end

  def render
    BLT.print(@x, @y, "[color=#{@color}][#{@char}]")
  end
end
