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

  def move(map, dx, dy)
    @x += dx
    @y += dy
  end

  def move_astar(map, target_x, target_y, dx, dy)
    path = A_Star.find_path(map, @x, @y, target_x, target_y)
    if !path.nil? && path.length < 25
      map.tiles[@x][@y].walkable = true
      @x, @y = *path.first
      map.tiles[@x][@y].walkable = false
    elsif map.tiles[@x+dx][@y+dy].walkable
      map.tiles[@x][@y].walkable = true
      move(map, dx, dy)
      map.tiles[@x][@y].walkable = false
    end
  end

  def move_towards(map, target_x, target_y)
    dx, dy = target_x - @x, target_y - @y
    distance = Math.sqrt(dx**2 + dy**2)
    dx, dy = (dx/distance).round, (dy/distance).round
    move_astar(map, target_x, target_y, dx, dy)
  end

  def get_entity_at(x, y)
    @entities.each { |entity| return entity if entity.x == x && entity.y == y }
    return nil
  end

  def render
    BLT.print(@x, @y, "[color=#{@color}][#{@char}]")
  end
end
