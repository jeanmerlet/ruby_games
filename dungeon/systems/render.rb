module Render

  def render_entity(map, entity, fov_id)
    if map.fov_tiles[entity.x][entity.y] == fov_id
      entity.render
    end
  end

  def clear_entity(entity)
    BLT.print(entity.x, entity.y, " ")
  end

  def render_all(map, entities)
    fov_id = entities.first.fov_id
    map.tiles.each_with_index do |tile_line, x|
      tile_line.each_with_index do |tile, y|
        if map.fov_tiles[x][y] == fov_id
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

    entities.each { |entity| render_entity(map, entity, fov_id) }
  end

  def clear_entities(entities)
    entities.each { |entity| clear_entity(entity) }
  end
end
