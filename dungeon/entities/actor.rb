class Actor
  attr_accessor :entities, :x, :y, :char, :color, :blocks, :name, :fov_id,
                :render_order, :combat, :ai, :status

  def initialize(entities, x, y, char, name, color, fov_id = nil, blocks = true)
    @entities = entities
    @entities.push(self)
    @x, @y = x, y
    @char, @name = char, name
    @color = BLT.color_from_name(color)
    @blocks = blocks
    @fov_id = fov_id
    @render_order = 1
  end

  def move(map, dx, dy)
    map.tiles[@x][@y].walkable = true
    @x += dx
    @y += dy
    map.tiles[@x][@y].walkable = false
  end

  def move_towards(map, target_x, target_y)
    dx, dy = target_x - @x, target_y - @y
    dx = (dx == 0 ? 0 : (dx > 0 ? 1 : -1))
    dy = (dy == 0 ? 0 : (dy > 0 ? 1 : -1))

    # path to target around obstacles if not too far
    path = A_Star.find_path(map, @x, @y, target_x, target_y)
    if !path.nil? && path.length < 20
      map.tiles[@x][@y].walkable = true
      @x, @y = *path.first
      map.tiles[@x][@y].walkable = false

    # otherwise slide along walls towards target
    elsif map.tiles[@x+dx][@y+dy].walkable
      move(map, dx, dy)
    elsif map.tiles[@x+dx][@y].walkable
      move(map, dx, 0)
    elsif map.tiles[@x][@y+dy].walkable
      move(map, 0, dy)
    end
  end

  def get_blocking_entity_at(x, y)
    @entities.each do |entity|
      return entity if entity.x == x && entity.y == y && entity.blocks
    end
    return nil
  end

  def render
    BLT.print(@x, @y, "[color=#{@color}]#{@char}")
  end
end
