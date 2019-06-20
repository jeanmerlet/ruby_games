module Render

  def render_entity(entity)
    BLT.print(entity.x, entity.y, "[color=#{entity.color}][#{entity.char}]")
  end

  def clear_entity(entity)
    BLT.print(entity.x, entity.y, " ")
  end

  def render_all(map, entities)
    map.tiles.each_with_index do |tile_line, x|
      tile_line.each_with_index do |tile, y|
        if tile.blocked
          BLT.print(x, y, "[color=dark_wall][0x1003]")
        else
          BLT.print(x, y, "[color=dark_ground][0x100E]")
        end
      end
    end

    entities.each { |entity| render_entity(entity) }
  end

  def clear_entities(entities)
    entities.each { |entity| clear_entity(entity) }
  end
end
