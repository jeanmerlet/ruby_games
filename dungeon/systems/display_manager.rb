module DisplayManager

  def self.render_all(map, entities, player, gui, game_states)
    if game_states.last != :show_inventory && game_states.last != :drop_item
      fov_id = player.fov_id
      map.render(fov_id)
      entities.sort! { |a, b| b.render_order <=> a.render_order }
      render_all_entities(map, entities, fov_id)
      gui.render
    else
      options, keys, items = {}, [*(:a..:z)], player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.display_menu('Inventory', options)
    end
  end

  private

  def self.render_all_entities(map, entities, fov_id)
    entities.each { |entity| render_entity(map, entity, fov_id) }
  end

  def self.render_entity(map, entity, fov_id)
    entity.render if map.fov_tiles[entity.x][entity.y] == fov_id
  end
end
