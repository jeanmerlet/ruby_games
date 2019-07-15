class Actor < Entity
  attr_accessor :fov_r, :fov_id, :combat, :inventory, :stats

  def initialize(entities, x, y, char, name, color, fov_r = nil, fov_id = nil)
    super(entities, x, y, char, color, name)
    @fov_r, @fov_id = fov_r, fov_id
    @render_order = 1
    @blocks, @can_pick_up = true, false
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

  def get_items_at(x, y)
    items = []
    @entities.each do |entity|
      items << entity if entity.x == x && entity.y == y && entity.can_pick_up
    end
    return items
  end
end
