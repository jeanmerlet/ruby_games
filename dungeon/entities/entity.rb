class Entity
  attr_accessor :entities, :x, :y, :char, :color, :name, :render_order, :ai,
                :status, :blocks, :combat, :can_pick_up

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

  def get_all_entities_at(x, y)
    entities = []
    @entities.each do |entity|
      entities << entity if entity.x == x && entity.y == y
    end
    return entities
  end

  def distance_to(x, y)
    return Math.sqrt((@x-x)**2 + (@y-y)**2)
  end

  def render(x, y)
    BLT.print(2*x, y, "[0xE002][+][font=char][color=#{@color}]#{@char}")
  end
end
