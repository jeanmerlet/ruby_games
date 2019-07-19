module DisplayManager

  def self.render(game_states, refresh_fov, map, viewport, gui, entities,
                  player, item)
    if refresh_fov
      player.fov_id += 1
      FieldOfView.do_fov(map, player)
    end
    viewport.refresh
    game_state = game_states.last
    if game_state == :open_inventory || game_state == :drop_item
      options, keys, items = {}, [*(:a..:z)], player.inventory.items
      items.map.with_index { |item, i| options[keys[i]] = item.name }
      Menu.render(viewport, 'Inventory', options)
    elsif game_state == :targetting || game_state == :inspecting
      render_targetting_grid(viewport, gui.target_info, player, item)
    elsif game_state == :inspect_details
      target = gui.target_info.target
      header = "[color=#{target.color}]#{target.name}"
      header_length = name.length
      TextBox.render(viewport, header, header_length, target.desc)
    end
    gui.render
    BLT.refresh
  end

  private

  def self.render_targetting_grid(viewport, target_info, player, item = nil)
    BLT.composition 1
    px, py = player.x, player.y
    x_off, y_off = viewport.x_off, viewport.y_off
    ret_x, ret_y = target_info.ret_x, target_info.ret_y
    vpx, vpy = ret_x - px + x_off, ret_y - py + y_off
    if item
      item.targetting.render_targetting_grid(vpx, vpy)
    else
      BLT.print(2*vpx, vpy, "[color=darker red][0xE000]")
    end
    BLT.composition 0
  end
end
