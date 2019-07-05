class MonsterAI < Component
  attr_accessor :take_turn

  def initialize(owner)
    super(owner)
    @chase_turns = 0
  end

  def take_turn(map, player)
    x, y = @owner.x, @owner.y
    player_x, player_y = player.x, player.y
    if map.fov_tiles[x][y] == player.fov_id - 1  #player can see monster
      @chase_turns = 3
      if distance_to(player_x, player_y) >= 2
        @owner.move_towards(map, player_x, player_y)
      elsif player.combat.hp > 0
      end
    elsif @chase_turns > 0 && distance_to(player_x, player_y) >= 2
      @owner.move_towards(map, player_x, player_y)
      @chase_turns -= 1
    end
  end

  def distance_to(target_x, target_y)
    return Math.sqrt((@owner.x - target_x)**2 + (@owner.y - target_y)**2)
  end
end
