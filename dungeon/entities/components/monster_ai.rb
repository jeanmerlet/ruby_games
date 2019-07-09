class MonsterAI
  attr_accessor :take_turn

  def initialize(owner)
    @owner = owner
    @chase_turns = 0
  end

  def take_turn(map, player)
    x, y = @owner.x, @owner.y
    player_x, player_y = player.x, player.y
    results = []
    if map.fov_tiles[x][y] == player.fov_id #player can see monster
      @owner.status = '[color=red]attacking!'
      @chase_turns = 3
      if distance_to(player_x, player_y) >= 2
        @owner.move_towards(map, player_x, player_y)
      elsif player.combat.hp.first > 0
        results.push(@owner.combat.attack(player))
      end
    elsif @chase_turns > 0 && distance_to(player_x, player_y) >= 2
      @owner.move_towards(map, player_x, player_y)
      @chase_turns -= 1
    end
    return results
  end

  def distance_to(target_x, target_y)
    return Math.sqrt((@owner.x - target_x)**2 + (@owner.y - target_y)**2)
  end
end
