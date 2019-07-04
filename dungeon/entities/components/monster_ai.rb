class MonsterAI < Component
  attr_accessor :take_turn

  def initialize(owner)
    super(owner)
    @attacking = false
  end

  def take_turn(map, player)
    x, y = @owner.x, @owner.y
    if map.fov_tiles[x][y] == player.fov_id - 1  #player can see monster
      player_x, player_y = player.x, player.y
      if distance_to(player_x, player_y) >= 2
        @owner.move_towards(map, player_x, player_y)
      elsif player.combat.hp > 0
      end
    end
  end

  def distance_to(target_x, target_y)
    return Math.sqrt((@owner.x - target_x)**2 + (@owner.y - target_y)**2)
  end
end
