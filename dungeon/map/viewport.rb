class Viewport
  attr_reader :width, :height

  def initialize(map, entities, player)
    @map, @entities, @player = map, entities, player
    @width = (Config::SCREEN_WIDTH - Config::SIDE_PANEL_WIDTH)/2
    @height = Config::SCREEN_HEIGHT - Config::VERT_PANEL_HEIGHT
    @x_off, @y_off = @width/2, @height/2
    @fps = 0
    @time_end = Time.now + 1
  end

  def refresh
    clear
    render
  end

  def clear
    BLT.clear_area(0, 0, 2*@width, @height)
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

    @entities.sort! { |a, b| b.render_order <=> a.render_order }
    @entities.each do |entity| 
      if @map.fov_tiles[entity.x][entity.y] == fov_id
        dx, dy = @x_off + (entity.x - px), @y_off + (entity.y - py)
        entity.render(dx, dy) 
      end
    end
  end
end
