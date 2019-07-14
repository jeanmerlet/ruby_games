module Destroy

  def self.kill_player(player)
    player.char = "%"
    player.color = BLT.color_from_name("darker red")
  end

  def self.player_death_message
    return "You died!"
  end

  def self.kill_monster(map, monster, target_info)
    monster.char = "%"
    monster.color = BLT.color_from_name("darker red")
    monster.blocks = false
    monster.combat = nil
    monster.ai = nil
    monster.name = "#{monster.name} corpse"
    monster.render_order = 3
    monster.status = 'dead.'
    map.tiles[monster.x][monster.y].walkable = true
    target_info.update_target if target_info.target == monster
  end

  def self.monster_death_message(monster)
    article = (/[aeiou]/ === monster.name[0] ? 'An' : 'A')
    return "#{article} #{monster.name} dies."
  end
end
