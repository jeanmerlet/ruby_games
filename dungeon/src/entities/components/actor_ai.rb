class ActorAI < Component

  def initialize(owner)
    super(owner)
    @chase_turns = 0
  end

  def take_turn(map, player)
    player_x, player_y = player.x, player.y
    results = []
    if map.fov_tiles[@owner.x][@owner.y] == player.fov_id
      @owner.status = '[color=red]attacking!'
      @chase_turns = 3
      if @owner.distance_to(player_x, player_y) >= 2
        @owner.move_towards(map, player_x, player_y)
      elsif player.combat.hp.first > 0
        results.push(@owner.combat.attack(player))
      end
    elsif @chase_turns > 0 && @owner.distance_to(player_x, player_y) >= 2
      @owner.move_towards(map, player_x, player_y)
      @chase_turns -= 1
    end
    return results
  end
end
