class Entity
  attr_accessor :entities, :x, :y, :char, :color, :name, :render_order, :ai,
                :status, :blocks, :combat, :can_pick_up, :desc

  def initialize(entities, x, y, char, color, name)
    @entities = entities
    @entities << self
    @x, @y = x, y
    @char, @name = char, name
    @color = BLT.color_from_name(color)
  end

  def get_blocking_entity_at(x, y)
    @entities.each do |entity|
      return entity if entity.x == x && entity.y == y && entity.blocks
    end
    return nil
  end

  def get_top_entity_at(x, y)
    entities = []
    @entities.each do |entity|
      entities << entity if entity.x == x && entity.y == y && entity.blocks
    end
    entities.sort! { |a, b| b.render_order <=> a.render_order }
    return entities.last if !entities.empty?
    return nil
  end

  def distance_to(x, y)
    return Math.sqrt((@x-x)**2 + (@y-y)**2)
  end

  def dist(x1, y1, x2, y2)
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)
  end
end
