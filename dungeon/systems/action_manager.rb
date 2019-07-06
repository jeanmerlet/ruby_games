module ActionManager

  def manage_action(action)
    if action && @state_stack.last == :player_turn
      results = []
      if action[:move]
        results.push(move_player(action[:move]))
      elsif action[:quit]
        @close = true
      end
      results.flatten!
      return results

    elsif @state_stack.last == :enemy_turn
      results = []
      @entities.each do |entity|
        if entity.ai
          results.push(entity.ai.take_turn(@map, @player))
        end
      end
      @state_stack.pop
      @state_stack << :player_turn
      results.flatten!
      return results

    elsif @state_stack.last == :player_death
      @close = true if BLT.read
      return []
    else
      return []
    end
  end

  def move_player(move)
    dx, dy = *move
    end_x, end_y = @player.x + dx, @player.y + dy
    results = []
    if !@map.tiles[end_x][end_y].blocked
      target = @player.get_blocking_entity_at(end_x, end_y)
      if target.nil?
        @player.move(@map, dx, dy)
        @refresh_fov = true
      else
        results.push(@player.combat.attack(target))
      end
      @player.fov_id += 1
      @state_stack.pop
      @state_stack << :enemy_turn
    else
      @refresh_fov = false
    end
    return results
  end
end
