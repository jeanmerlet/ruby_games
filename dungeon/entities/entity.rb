class Entity
  attr_accessor :entities, :x, :y, :char, :color, :name, :render_order, :ai,
                :targetted, :status, :blocks, :can_pick_up, :combat

  def initialize(entities, x, y, char, color, name)
    @entities = entities
    @entities << self
    @x, @y = x, y
    @char, @name, @blocks = char, name, blocks
    @color = BLT.color_from_name(color)
  end

  def get_blocking_entity_at(x, y)
    @entities.each do |entity|
      return entity if entity.x == x && entity.y == y && entity.blocks
    end
    return nil
  end

  def distance(x, y)
    return Math.sqrt((@x-x)**2 + (@y-y)**2)
  end

  def render
    if @targetted
      BLT.print(2*@x, @y, "[0xE000][+][font=reg][color=#{@color}]#{@char}")
    else
      BLT.print(2*@x, @y, "[font=reg][color=#{@color}]#{@char}")
    end
  end
end
