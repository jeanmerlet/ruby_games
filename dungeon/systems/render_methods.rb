def render_entity(entity)
  BLT.print(entity.x, entity.y, "[color=#{entity.color}][#{entity.char}]")
end

def clear_entity(entity)
  BLT.print(entity.x, entity.y, " ")
end

def render_entities(entities)
  entities.each { |entity| render_entity(entity) }
end

def clear_entities(entities)
  entities.each { |entity| clear_entity(entity) }
end

def render_map(map)
  map.tiles.each do |tile|
    BLT.print(tile.x)
  end
end
