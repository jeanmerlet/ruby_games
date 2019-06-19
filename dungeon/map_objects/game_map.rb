class GameMap
  attr_accessor :tiles

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = initialize_tiles
    generate_map
  end

  def initialize_tiles
    Array.new(@width) { Array.new(@height) { Tile.new(true) } }
  end

  def generate_map
    room1 = Rect.new(20, 15, 10, 15)
    room2 = Rect.new(35, 15, 10, 15)
    create_room(room1)
    create_room(room2)
    create_h_tunnel(25, 40, 23)
  end

  def create_room(room)
    @tiles[room.x1+1..room.x2-1].each do |h_tile_line|
      h_tile_line[room.y1+1..room.y2-1].each do |tile|
        tile.blocked = false
      end
    end
  end

  def create_h_tunnel(x1, x2, y)
    @tiles[x1..x2+1].each do |h_tile_line|
      h_tile_line[y].blocked = false
    end
  end

  def create_v_tunnel(y1, y2, x)
    @tiles[x][y1..y2+1].each { |tile| tile.blocked = false }
  end

  def blocked?(x, y)
    return true if @tiles[x][y].blocked
    false
  end
end
