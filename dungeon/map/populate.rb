module Populate

  def self.place_entities(tiles, room, entities, monster_max, item_max)
    place_actors(tiles, room, entities, monster_max)
    place_items(tiles, room, entities, item_max)
  end

  def self.place_actors(tiles, room, entities, monster_max)
    number_of_monsters = rand(0..monster_max)
    number_of_monsters.times do
      x, y = *get_xy(room)
      if !spot_occupied?(entities, x, y)
        if rand(100) < 80
          monster = Actor.new(entities, x, y, "s", "skitterling", "purple")
          monster.status = "skittering around. Obviously."
          hp, defense, power = 10, 0, 3
          monster.combat = Combat.new(monster, hp, defense, power)
          monster.ai = ActorAI.new(monster)
          monster.desc = "One of the weakest Hivespawn, the skitterling is reminiscent of a giant, purplish cockroach. Infestations are common in badly-maintained stations, though they require a Queen to breed. They are not very intelligent, and will attack and try to eat just about anything that moves, except other Hivespawn. It has six legs ending in sharp points, which it uses to skewer its victims. It is fast."

        else
          monster = Actor.new(entities, x, y, "R", "rust sentry", "dark gray")
          monster.status = "patrolling."
          hp, defense, power = 16, 1, 4
          monster.combat = Combat.new(monster, hp, defense, power)
          monster.ai = ActorAI.new(monster)
          monster.desc = "An old and partly broken-down station guardbot, it still packs some serious heat. Literally. It has some kind of flamethrower at the ready. You can usually rely on these to loop through fairly obvious routines, but this one may have had some (or most) of its logic circuits fried. It is slow."
        end
        tiles[x][y].entities << monster
      end
    end
  end

  def self.place_items(tiles, room, entities, item_max)
    number_of_items = rand(0..item_max)
    number_of_items.times do
      x, y = *get_xy(room)
      if !spot_occupied?(entities, x, y)
        if rand(100) < 70
          item = Consumable.new(entities, x, y, "!", "FERNS", "light blue")
          item.status = "full of [color=light blue]nano-mending bots[/color]."
          item.effects << Heal.new(item, 15)
          item.messages << "[color=light blue]regenerated[/color] by the FERNS."
          item.targetting = SelfTarget.new(item)
          item.desc = "Fast-acting, Energizing & Regenerative Nanobots (FERNS). More like immediately-acting. Contained in a disposable jet injector, these are indispensable and ultra-convenient, but also rare and expensive."
        else
          item = Consumable.new(entities, x, y, "*", "frag grenade", "dark gray")
          item.status = "packed with deadly [color=dark gray]shrapnel[/color]."
          item.effects << Damage.new(item, :piercing, 15)
          item.messages << "[color=dark gray]shredded[/color] by the shrapnel!"
          item.targetting = CircularAOE.new(item, 2)
          item.desc = "This technology has been around for a very long time. Designed to explosively disperse sharp metal shards in a radius on impact, one of these can clear out several threats at once if well-aimed. It can be lobbed over enemies."
        end
        tiles[x][y].entities << item
      end
    end
  end

  def self.get_xy(room)
    if room.is_a?(Rect)
      x = rand(room.x1 + 1..room.x2 - 1)
      y = rand(room.y1 + 1..room.y2 - 1)
    else
      r = rand(0.0..1.0)
      theta = rand(0.0..6.28)
      x = ((room.r - 1.5)*(Math.sqrt(r)*Math.cos(theta))).round + room.x
      r = rand(0.0..1.0)
      theta = rand(0.0..6.28)
      y = ((room.r - 1.5)*(Math.sqrt(r)*Math.sin(theta))).round + room.y
    end
    return [x, y]
  end

  def self.spot_occupied?(entities, x, y)
    entities.each do |entity|
      return true if x == entity.x && y == entity.y
    end
    false
  end
end
