class GameMap

  def initialize(width, height)
    @width = width
    @height = height
    @tiles = initialize_tiles
    place_start_room
  end

  def initialize_tiles
    Array.new(@width) { Array.new(@height) { Floor.new(true) } }
  end

  def place_start_room
    
  end
end
