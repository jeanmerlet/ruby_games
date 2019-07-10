module Render

  def render_all
    if @game_states.last != :show_inventory
      fov_id = @player.fov_id
      @map.render(fov_id)
      render_gui
      clear_entities
      @entities.sort! { |a, b| b.render_order <=> a.render_order }
      render_entities(fov_id)
    else
      
    end
  end

  def render_gui
    @hp_bar.render
    @target_display.render
    @log.render
  end

  def render_entities(fov_id)
    @entities.each { |entity| render_entity(entity, fov_id) }
  end

  def render_entity(entity, fov_id)
    entity.render if @map.fov_tiles[entity.x][entity.y] == fov_id
  end

  def clear_entities
    @entities.each { |entity| clear_entity(entity) }
  end

  def clear_entity(entity)
    BLT.print(entity.x, entity.y, " ")
  end
end
