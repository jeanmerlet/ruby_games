class GameMap
  attr_reader :width, :height, :tiles, :fov_tiles
  include ShapeMath
  include Populate
  include GenerateLevel

  def initialize(width, height, seed = nil)
    @width = width
    @height = height
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new(true) } }
    @fov_tiles = Array.new(@width) { Array.new(@height) { 0 } }
    seed = rand(10000) if seed.nil?
    p seed
    srand(seed)
  end

  def render(fov_id)
    @tiles.each_with_index do |tile_line, x|
      tile_line.each_with_index do |tile, y|
        if @fov_tiles[x][y] == fov_id
          if tile.blocked
            BLT.print(x, y, "[color=light_wall][0x1003]")
          else
            BLT.print(x, y, "[color=light_ground][0x100E]")
          end
        else
          if tile.explored
            if tile.blocked
              BLT.print(x, y, "[color=dark_wall][0x1003]")
            else
              BLT.print(x, y, "[color=dark_ground][0x100E]")
            end
          end
        end
      end
    end
  end
end
