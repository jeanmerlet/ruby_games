class GameMap
  attr_accessor :tiles

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = initialize_tiles
    place_start_room
  end

  def initialize_tiles
    Array.new(@width) { Array.new(@height) { Tile.new(true) } }
  end

  def place_start_room
    10.times do |i|
      10.times do |j|
        tile = @tiles[i + 35][j + 20]
        tile.blocked = false
        tile.block_sight = false
      end
    end
  end
end
