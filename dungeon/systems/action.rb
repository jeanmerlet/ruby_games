module Action

 def do_action(action)
    if action[:move]
      if move_player(*action[:move])
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

  def move_player(dx, dy)
    if !@map.tiles[@player.x + dx][@player.y + dy].blocked
      target = get_entity_at(@player.x + dx, @player.y + dy)
      if !target
        @player.x += dx
        @player.y += dy
        true
      else
        false
      end
    end
  end

  def get_entity_at(x, y)
    @entities.each do |entity|
      return entity if entity.x == x && entity.y == y
    end
    false
  end
end
