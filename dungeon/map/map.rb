class Map
  attr_reader :width, :height, :tiles, :fov_tiles

  def initialize(seed = nil)
    @width, @height = 70, 50
    @side_min, @side_max = 3, 5
    @monster_max, @item_max = 3, 2
    @room_tries = 60
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new } }
    @fov_tiles = Array.new(@width) { Array.new(@height) { 0 } }
    seed = rand(10000) if seed.nil?
    srand(seed)
    p seed
  end

  def new_level(entities, player)
    rooms = []
    @room_tries.times do |i|
      new_room = new_shape
      if !any_intersection?(rooms, new_room, 0)
        create_room(new_room)
        new_x, new_y = *new_room.center
        if i == 0
          if new_room.is_a?(Circ)
            player.x, player.y = new_x, new_y
          else
            player.x, player.y = new_x + 1, new_y + 1
          end
          @tiles[player.x][player.y].entities << player
        else
          Populate.place_entities(@tiles, new_room, entities, @monster_max,
                                  @item_max)
          prev_x, prev_y = *rooms.last.center
          toss = rand(2)
          if toss == 0
            create_h_tunnel(prev_x, new_x, prev_y)
            create_v_tunnel(prev_y, new_y, new_x)
          else
            create_v_tunnel(prev_y, new_y, prev_x)
            create_h_tunnel(prev_x, new_x, new_y)
          end
        end
        rooms << new_room
      end
    end
    bevel_tiles
  end

  def new_shape
    toss = rand(2)
    if toss == 0
      r = @side_min + 1 + rand(@side_max - @side_min + 2)
      x, y = r + rand(@width - 2*r), r + rand(@height - 2*r)
      Circ.new(x, y, r)
    else
      w = 2*@side_min + rand(2*(@side_max - @side_min) + 1)
      h = 2*@side_min + rand(2*(@side_max - @side_min) + 1)
      x, y = rand(@width - w - 1), rand(@height - h - 1)
      Rect.new(x, y, w, h)
    end
  end

  def any_intersection?(rooms, new_room, overlap)
    rooms.each { |room| return true if intersect?(new_room, room, overlap) }
    false
  end

  def intersect?(room1, room2, overlap)
    if room1.is_a?(Rect) && room2.is_a?(Rect)
      ShapeMath.rect_rect_intersect?(room1, room2, overlap)
    elsif room1.is_a?(Circ) && room2.is_a?(Circ)
      ShapeMath.circ_circ_intersect?(room1, room2, overlap)
    else
     if room1.is_a?(Circ)
      ShapeMath.circ_rect_intersect?(room1, room2, overlap)
     else
      ShapeMath.circ_rect_intersect?(room2, room1, overlap)
     end
    end
  end

  def create_room(room)
    if room.is_a?(Circ)
      create_circ_room(room)
    elsif room.is_a?(Rect)
      create_rect_room(room)
    end
  end

  def create_rect_room(room)
    @tiles[room.x1+1..room.x2].each do |h_tile_line|
      h_tile_line[room.y1+1..room.y2].each do |tile|
        tile.blocked = false
        tile.walkable = true
      end
    end
  end

  def create_circ_room(room)
    x, r = 0, room.r - 0.5
    quadrant = []
    room.r.times do |i|
      x += 1
      y = 0
      room.r.times do
        y += 1
        quadrant << [x + room.x, y + room.y] if x*x + y*y <= r*r
      end
    end

    half = quadrant + quadrant.map { |coords| [2*room.x - coords[0], coords[1]] }
    room.r.times do |i|
      half << [room.x, room.y + i]
    end
    whole = half + half.map { |coords| [coords[0], 2*room.y - coords[1]] }
    (room.r*2 - 1).times do |i|
      whole << [room.x - room.r + i + 1, room.y]
    end

    whole.each do |xy|
      tile = @tiles[xy[0]][xy[1]]
      tile.blocked = false
      tile.walkable = true
    end
  end

  def create_h_tunnel(x1, x2, y)
    x1, x2 = x2, x1 if x1 > x2
    @tiles[x1..x2].each do |h_tile_line|
      h_tile_line[y].blocked = false
      h_tile_line[y].walkable = true
    end
  end

  def create_v_tunnel(y1, y2, x)
    y1, y2 = y2, y1 if y1 > y2
    @tiles[x][y1..y2].each do |tile|
      tile.blocked = false
      tile.walkable = true
    end
  end

  def bevel_tiles
    @tiles.each_with_index do |tile_line, x|
      next if x == 0
      break if x == @width - 1
      tile_line.each_with_index do |tile, y|
        next if y == 0 || !tile.blocked
        break if y == @height - 1
        neighbors = neighbor_block_values(x, y)
        block_count = neighbors.count(true)
        if block_count < 3
          n, s, e, w = *neighbors
          if block_count == 2
            if !n && !w
              tile.bevel_nw = true
            elsif !n && !e
              tile.bevel_ne = true
            elsif !s && !e
              tile.bevel_se = true
            elsif !s && !w
              tile.bevel_sw = true
            end
          elsif block_count == 1
            if n
              tile.bevel_sw, tile.bevel_se = true, true
            elsif s
              tile.bevel_nw, tile.bevel_ne = true, true
            elsif e
              tile.bevel_nw, tile.bevel_sw = true, true
            else
              tile.bevel_ne, tile.bevel_se = true, true
            end
          else
            tile.bevel_nw = true
            tile.bevel_ne = true
            tile.bevel_sw = true
            tile.bevel_se = true
          end
        end
      end
    end
  end

  def neighbor_block_values(x, y)
    [@tiles[x][y-1].blocked, @tiles[x][y+1].blocked,
     @tiles[x+1][y].blocked, @tiles[x-1][y].blocked]
  end

  def out_of_bounds?(x, y)
    x < 0 || x >= @width || y < 0 || y >= @height
  end
end
