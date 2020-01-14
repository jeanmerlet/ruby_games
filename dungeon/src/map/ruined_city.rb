class Map
  attr_accessor :tiles, :fov_tiles
  attr_reader :width, :height

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

def new_level
end



end
