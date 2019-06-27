module Action

 def do_action(action)
    if action[:move]
      move_player(*action[:move])
      @player.fov_id += 1
      @refresh_fov = true
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
      @player.x += dx
      @player.y += dy
    end
  end
end
