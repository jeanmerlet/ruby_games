module Render

  def render
    fov_id = @player.fov_id
    @map.render(fov_id)
    @entities.each { |entity| render_entity(entity, fov_id) }
  end

  def render_entity(entity, fov_id)
    if @map.fov_tiles[entity.x][entity.y] == fov_id
      entity.render
    end
  end

  def clear_entities
    @entities.each { |entity| clear_entity(entity) }
  end

  def clear_entity(entity)
    BLT.print(entity.x, entity.y, " ")
  end
end
