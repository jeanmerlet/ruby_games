module DisplayManager

  def self.render_all(viewport, entities, player, gui, item, game_state)
    if game_state == :player_turn || game_state == :enemy_turn
      render_viewport(viewport)
    elsif game_state == :show_inventory || game_state == :drop_item
      options, keys, items = {}, [*(:a..:z)], player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.display_menu(viewport, 'Inventory', options)
    elsif game_state == :targetting || game_state == :inspecting
      render_viewport
      if game_state == :targetting
        render_target_area(gui.target_info, item)
      else
        render_target_area(gui.target_info)
      end
    elsif game_state
    end
    gui.render
  end

  def self.render_target_grid(target_info, item = nil)
    BLT.composition 1
    x, y = target_info.ret_x, target_info.ret_y
    if item
      item.targetting.render_target_area(x, y)
    else
      BLT.print(2*x, y, "[color=darker red][0xE000]")
    end
    BLT.composition 0
  end

  def self.render_viewport(viewport)
    viewport.clear
    viewport.render
  end
end
