class Creature < Entity
  attr_accessor :x, :y, :combat, :ai, :fov_id
  attr_reader   :char, :color, :name, :blocks

  def initialize(entities, x, y, char, name, color, fov_id = nil, blocks = true)
    super(entities)
    @x, @y = x, y
    @char, @name = char, name
    @color = BLT.color_from_name(color)
    @blocks = blocks
    @fov_id = fov_id
  end

  def update
  end

  def move(dx, dy)
    @x += dx
    @y += dy
  end

  def move_astar(map, target)
    distance = (@x + target[0])**2 + (@y + target[1])**2
    path = []
    untried = [[[@x, @y], 0]]
    until untried.empty?
      tile = untried.sort_by(smallest f)
      return path if current_tile == target
      
    end
    return nil
  end

  def move_towards(map, target_x, target_y)
    dx, dy = target_x - @x, target_y - @y
    distance = Math.sqrt(dx**2 + dy**2)
    dx, dy = (dx/distance).round, (dy/distance).round
    if !map.tiles[@x + dx][@y + dy].blocked && !get_entity_at(dx, dy)
      move(dx, dy)
    end
  end

  def get_entity_at(x, y)
    @entities.each { |entity| return entity if entity.x == x && entity.y == y }
    return nil
  end

  def render
    BLT.print(@x, @y, "[color=#{@color}][#{@char}]")
  end
end
