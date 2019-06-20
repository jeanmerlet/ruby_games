class GameMap
  attr_reader :tiles

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new(true) } }
  end

  def generate_level(min_length, max_length, max_rooms, player)
    rooms = []
    max_rooms.times do |i|
      w = min_length + rand(max_length - min_length + 1)
      h = min_length + rand(max_length - min_length + 1)
      x, y = rand(@width - w), rand(@height - h)
      new_room = Rect.new(x, y, w, h)

      if !any_intersection?(rooms, new_room)
        create_room(new_room) 
        new_x, new_y = *new_room.center
        if i == 0
          player.x, player.y = new_x + 1, new_y + 1
        else
          prev_x, prev_y = *rooms.last.center
          toss = rand(1)
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
  end

  def any_intersection?(rooms, new_room)
    rooms.each { |room| return true if new_room.intersect?(room) }
    false
  end

  def blocked?(x, y)
    @tiles[x][y].blocked ? true : false
  end

  def create_room(room)
    @tiles[room.x1+1..room.x2].each do |h_tile_line|
      h_tile_line[room.y1+1..room.y2].each do |tile|
        tile.blocked = false
      end
    end
  end

  def create_h_tunnel(x1, x2, y)
    x1, x2 = x2, x1 if x1 > x2
    @tiles[x1..x2].each do |h_tile_line|
      h_tile_line[y].blocked = false
    end
  end

  def create_v_tunnel(y1, y2, x)
    y1, y2 = y2, y1 if y1 > y2
    @tiles[x][y1..y2].each { |tile| tile.blocked = false }
  end
end
