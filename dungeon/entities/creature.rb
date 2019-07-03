class Creature < Entity
  attr_accessor :x, :y, :combat, :ai, :fov_id
  attr_reader   :char, :color, :name, :blocks

  def initialize(entity_pool, x, y, char, name, color)
    super(entity_pool)
    @x, @y = x, y
    @char, @name = char, name
    @color = BLT.color_from_name(color)
    @blocks = true
    @fov_id = 1
  end

  def update
  end

  def render
    BLT.print(@x, @y, "[color=#{@color}][#{@char}]")
  end
end
