module ActionManager

 def manage_action(action)
   do_action(action)
   if @game_state == GameStates::ENEMY_TURN
     do_enemy_turn
     @game_state = GameStates::PLAYER_TURN
   end
 end

 def do_action(action)
    if action[:move]
      if move_player(action[:move])
        @player.fov_id += 1
        @refresh_fov = true
      end
    elsif false
      #other fov-refreshing actions
    else
      @refresh_fov = false
      if false #all other non-fov refreshing actions
      end
    end
  end

  def move_player(move)
    dx, dy = *move
    end_x, end_y = @player.x + dx, @player.y + dy
    if @game_state == GameStates::PLAYER_TURN
      if !@map.tiles[end_x][end_y].blocked
        target = get_entity_at(end_x, end_y)
        if target.nil?
          @player.x += dx
          @player.y += dy
          @game_state = GameStates::ENEMY_TURN
          true
        else
          false
        end
      end
    end
  end

  def do_enemy_turn
    @entities.each do |entity|
      next if !entity.ai
      #puts "#{entity.name} does nothing. BLAURUGHH!"
    end
  end

  def get_entity_at(x, y)
    @entities.each do |entity|
      return entity if entity.x == x && entity.y == y
    end
    nil
  end
end
