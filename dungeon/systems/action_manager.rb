module ActionManager

  def manage_action(action)
    results = []
    game_state = @game_states.last
    if action
      if game_state == :player_turn
        if action[:move]
          results.push(move_player(action[:move]))
        elsif action[:inspecting]
          @game_states << :inspecting
          @active_cmd_domains.delete(:main)
          @active_cmd_domains << :targetting
          @gui.target_info = TargetInfo.new(@map, @entities, @player)
        elsif action[:pick_up]
          results.push(pick_up_item)
        elsif action[:inventory] || action[:drop]
          @game_states << (action[:inventory] ? :show_inventory : :drop_item)
          @active_cmd_domains.delete(:main)
          @active_cmd_domains << :menu
        elsif action[:quit]
          @close = true
        end

      elsif game_state == :targetting || game_state == :inspecting
        if action[:next_target]
          @gui.target_info.next_target
        elsif action[:move]
          @gui.target_info.move_reticule(action[:move], @player)
        elsif action[:select_target]
          if game_state == :targetting
            x, y = @gui.target_info.ret_x, @gui.target_info.ret_y
            results.push(@player.inventory.use_item(@item, x, y))
            2.times { @game_states.pop }
            action[:quit] = true
          elsif game_state == :inspecting
          end
        end
        if action[:quit]
          DisplayManager.render_map_area(@map, @entities, @player)
          @item = nil
          @gui.target_info.clear
          @gui.target_info = nil
          @game_states.pop if @game_states.last == :targetting
          @game_states.pop
          @active_cmd_domains.delete(:targetting)
          @active_cmd_domains << :main
        end

      elsif game_state == :show_inventory || game_state == :drop_item
        if action[:option_index]
          results.push(select_inv_item(action[:option_index], game_state))
        end
        if action[:quit]
          @game_states.pop
          @active_cmd_domains.delete(:menu)
          @active_cmd_domains << :main
        end
      end

    elsif game_state == :enemy_turn
      @entities.each do |entity|
        if entity.ai
          results.push(entity.ai.take_turn(@map, @player, @gui))
        end
      end
      @game_states << :player_turn

    elsif game_state == :player_death
      @close = true if BLT.read
    end
    results.flatten!
    return results
  end

  private

  def pick_up_item
    results = []
    x, y = @player.x, @player.y
    item = @player.get_items_at(x, y).first
    if item
      results.push(@player.inventory.pick_up(item))
      @game_states.pop
    else
      results.push({ message: "There's nothing there." })
    end
    return results
  end

  def drop_item(action, index)
    results = []
    item = @player.inventory.items[index]
    if item
      @game_states.pop
    end
    return results
  end

  def select_inv_item(index, game_state)
    results = []
    item = @player.inventory.items[index]
    if item
      if game_state == :show_inventory
        if item.is_a?(Consumable)
          @item = item
          @gui.target_info = TargetInfo.new(@map, @entities, @player)
          @game_states << :targetting
          @active_cmd_domains.delete(:menu)
          @active_cmd_domains << :targetting
          @active_cmd_domains << :movement
        else
          #equipment
        end
      elsif game_state == :drop_item
        results.push(@player.inventory.drop_item(item))
        @game_states.pop
        @active_cmd_domains.delete(:menu)
        @active_cmd_domains << :main
      end
    end
    return results
  end

  def move_player(move)
    dx, dy = *move
    end_x, end_y = @player.x + dx, @player.y + dy
    results = []
    if !@map.tiles[end_x][end_y].blocked
      target = @player.get_blocking_entity_at(end_x, end_y)
      if target.nil? || target == @player
        @player.move(@map, dx, dy)
      else
        results.push(@player.combat.attack(target))
      end
      @refresh_fov = true
      @player.fov_id += 1
      @game_states.pop
    end
    return results
  end
end
