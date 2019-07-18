module DisplayManager

  def self.render_all(game_states, refresh_fov, map, viewport, gui, entities,
                      player, item)
    if refresh_fov
      player.fov_id += 1
      FieldOfView.do_fov(map, player)
    end
    viewport.refresh
    game_state = game_states.last
    if game_state == :show_inventory || game_state == :drop_item
      options, keys, items = {}, [*(:a..:z)], player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.display_menu(viewport, 'Inventory', options)
    elsif game_state == :targetting || game_state == :inspecting
      render_target_grid(gui.target_info, item)
    end
    gui.render
    BLT.refresh
  end

  private

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
end
