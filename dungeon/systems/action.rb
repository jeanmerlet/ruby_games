module ActionManager

  def manage_action(action)
    if @state_stack.last == :player_turn
      do_action(action)
      do_enemy_turn if @state_stack.last == :enemy_turn
    end
  end

  def do_action(action)
    move_player(action[:move]) if action[:move]
    @close = true if action[:quit]
  end

  def move_player(move)
    dx, dy = *move
    end_x, end_y = @player.x + dx, @player.y + dy
    if !@map.tiles[end_x][end_y].blocked
      target = @player.get_entity_at(end_x, end_y)
      if target.nil?
        @player.move(dx, dy)
        @player.fov_id += 1
        @refresh_fov = true
        @state_stack.pop
        @state_stack << :enemy_turn
      end
    else
      @refresh_fov = false
    end
  end

  def do_enemy_turn
    @entities.each do |entity|
      if entity.ai
        entity.ai.take_turn(@map, @player)
      end
    end
    @state_stack.pop
    @state_stack << :player_turn
  end

  def do_monster_alert
    @entities.each do |entity|
      x, y = entity.x, entity.y
      if @map.fov_tiles[x][y] == @player.fov_id
        BLT.print(x, y, '!')
      end
    end
  end
end
