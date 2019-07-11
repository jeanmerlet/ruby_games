module ActionManager

  def manage_action(action)
    results = []
    if action && @game_states.last == :player_turn
      if action[:move]
        results.push(move_player(action[:move]))
      elsif action[:next_target]
        @target_display.next_target
      elsif action[:pick_up]
        results.push(pick_up_item)
      elsif action[:inventory]
        @active_cmd_domains.delete(:main)
        @active_cmd_domains << :inventory
        @game_states << :show_inventory
      elsif action[:quit]
        @close = true
      end

    elsif action && @game_states.last == :show_inventory
      if action[:quit]
        @game_states.pop
        BLT.clear
        @active_cmd_domains.delete(:inventory)
        @active_cmd_domains << :main
      end

    elsif @game_states.last == :enemy_turn
      @entities.each do |entity|
        if entity.ai
          results.push(entity.ai.take_turn(@map, @player))
        end
      end
      @game_states.pop
      @game_states << :player_turn

    elsif @game_states.last == :player_death
      @close = true if BLT.read
    end
    results.flatten!
    return results
  end

  def pick_up_item
    results = []
    x, y = @player.x, @player.y
    items = @player.get_items_at(x, y)
    if !items.empty?
      results.push(@player.inventory.pick_up(items[0]))
      @game_states.pop
      @game_states << :enemy_turn
    else
      results.push({ message: "There's nothing there." })
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
      @game_states << :enemy_turn
    end
    return results
  end
end
