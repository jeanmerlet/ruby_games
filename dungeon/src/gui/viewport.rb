class Viewport
  attr_reader :width, :height, :x_off, :y_off

  def initialize(map, entities, player)
    @map, @entities, @player = map, entities, player
    @width = (Config::SCREEN_WIDTH - Config::SIDE_PANEL_WIDTH)/2
    @height = Config::SCREEN_HEIGHT - Config::VERT_PANEL_HEIGHT
    @x_off, @y_off = @width/2, @height/2
  end

  def refresh
    clear
    render
  end

  def render
    px, py = @player.x, @player.y
    fov_id = @player.fov_id

    @width.times do |i|
      @height.times do |j|
        x, y = px - @x_off + i, py - @y_off + j
        if !@map.out_of_bounds?(x, y)
          tile = @map.tiles[x][y]
          if @map.fov_tiles[x][y] == fov_id
            if tile.blocked
              BLT.print(2*i, j, "[color=light_wall][font=bold]#")
            else
              BLT.print(2*i, j, "[color=light_floor][font=char]·")
            end
            if !tile.entities.empty?
              color, char = tile.entities.last.color, tile.entities.last.char
              BLT.print(2*i, j, "[font=char][color=#{color}]#{char}")
            end
          else
            if tile.explored
              if tile.blocked
                BLT.print(2*i, j, "[color=unlit][font=bold]#")
              else
                BLT.print(2*i, j, "[color=unlit][font=char]·")
              end
            end
          end
        end
      end
    end
  end

  def clear
    BLT.clear_area(0, 0, 2*@width, @height)
  end
end
