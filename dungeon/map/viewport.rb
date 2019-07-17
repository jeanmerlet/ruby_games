class Viewport
  attr_reader :width, :height

  def initialize(map, entities, player)
    @map, @entities, @player = map, entities, player
    @width = (Config::SCREEN_WIDTH - Config::SIDE_PANEL_WIDTH)/2
    @height = Config::SCREEN_HEIGHT - Config::VERT_PANEL_HEIGHT
    @x_off, @y_off = @width/2, @height/2
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
            entities = @player.get_all_entities_at(x, y)
            if !entities.empty?
              entities.sort! { |a, b| b.render_order <=> a.render_order }
              render_entities(entities, x, y, i, j, fov_id)
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

  def render_entities(entities, x, y, i, j, fov_id)
    entities.each do |entity|
      entity.render(i, j) if @map.fov_tiles[x][y] == fov_id
    end
  end

  def render_targetting_grid(coords)
    coords.each { |coord_pair| BLT.print(2*) }
  end

  def clear
    BLT.clear_area(0, 0, 2*@width, @height)
  end
end
