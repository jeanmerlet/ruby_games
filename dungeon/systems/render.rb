module RenderManager

  def render_all
    if @game_states.last != :show_inventory
      clear_entities
      fov_id = @player.fov_id
      @map.render(fov_id)
      render_gui
      @entities.sort! { |a, b| b.render_order <=> a.render_order }
      render_entities(fov_id)
    else
      options, keys, items = {}, [*(:a..:z)], @player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.display_menu('Inventory', options)
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
