class GameMap
  attr_accessor :tiles

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = initialize_tiles
    create_room(Rect.new(1, 1, 5, 5))
  end

  def initialize_tiles
    Array.new(@width) { Array.new(@height) { Tile.new(true) } }
  end

  def create_room(room)
    @tiles[room.x1+1..room.x2-1].each do |h_tile_line|
      h_tile_line[room.y1+1..room.y2-1].each do |tile|
        tile.blocked = false
      end
    end
  end

  def blocked?(x, y)
    return true if @tiles[x][y].blocked
    false
  end
end
