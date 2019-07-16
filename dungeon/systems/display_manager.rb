module DisplayManager

  def self.render_all(map, entities, player, gui, item, game_state)
    if game_state == :player_turn || game_state == :enemy_turn
      render_map_area(map, entities, player)
    elsif game_state == :show_inventory || game_state == :drop_item
      options, keys, items = {}, [*(:a..:z)], player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.display_menu('Inventory', options)
    elsif game_state == :targetting
      render_map_area(map, entities, player)
      BLT.composition 1
      fov_id = player.fov_id
      target = gui.target_info.target
      item.targetting.render_target_area(map, fov_id, target) if target
      BLT.composition 0
    end
    gui.render
  end

  def self.render_map_area(map, entities, player)
    fov_id = player.fov_id
    map.clear
    map.render(fov_id)
    entities.sort! { |a, b| b.render_order <=> a.render_order }
    render_all_entities(map, entities, fov_id)
  end

  private

  def self.render_all_entities(map, entities, fov_id)
    entities.each { |entity| render_entity(map, entity, fov_id) }
  end

  def self.render_entity(map, entity, fov_id)
    entity.render if map.fov_tiles[entity.x][entity.y] == fov_id
  end

  def self.clear_entities(entities)
    entities.each { |entity| BLT.print(2*entity.x, entity.y, "[0xE003]") }
  end
end