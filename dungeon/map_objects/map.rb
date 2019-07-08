class Map
  attr_reader :width, :height, :tiles, :fov_tiles
  include GenerateLevel

  def initialize(width, height, seed = nil)
    @width = width
    @height = height
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new } }
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
            BLT.print(x, y, "[color=light_wall][font=extra_bold]#")
          else
            BLT.print(x, y, "[color=light_floor]·")
          end
        else
          if tile.explored
            if tile.blocked
              BLT.print(x, y, "[color=gray][font=extra_bold]#")
            else
              BLT.print(x, y, "[color=gray]·")
            end
          end
        end
      end
    end
  end
end
