class Actor < Entity
  attr_accessor :fov_r, :fov_id, :combat, :inventory, :stats

  def initialize(entities, x, y, char, name, color, fov_r = nil, fov_id = nil)
    super(entities, x, y, char, color, name)
    @fov_r, @fov_id = fov_r, fov_id
    @render_order = 1
    @blocks, @can_pick_up = true, false
  end

  def move(map, dx, dy)
    map.tiles[@x][@y].passable = true
    map.tiles[@x][@y].remove_entity(self)
    @x += dx
    @y += dy
    map.tiles[@x][@y].passable = false
    map.tiles[@x][@y].add_entity(self)
  end

  def move_towards(map, target_x, target_y)
    dx, dy = target_x - @x, target_y - @y
    dx = (dx == 0 ? 0 : (dx > 0 ? 1 : -1))
    dy = (dy == 0 ? 0 : (dy > 0 ? 1 : -1))

    # path to target around obstacles if not too far
    path = A_Star.find_path(map, @x, @y, target_x, target_y)
    if !path.nil? && path.length < 20
      new_x, new_y = *path.first
      dx, dy = new_x - @x, new_y - @y
      move(map, dx, dy)

    # otherwise slide along walls towards target
    elsif map.tiles[@x+dx][@y+dy].passable
      move(map, dx, dy)
    elsif map.tiles[@x+dx][@y].passable
      move(map, dx, 0)
    elsif map.tiles[@x][@y+dy].passable
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
