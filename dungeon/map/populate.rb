module Populate

  def self.place_entities(room, entities, monster_max, item_max)
    place_actors(room, entities, monster_max)
    place_items(room, entities, item_max)
  end

  def self.place_actors(room, entities, monster_max)
    number_of_monsters = rand(0..monster_max)
    number_of_monsters.times do
      x, y = *get_xy(room)
      if !spot_occupied?(entities, x, y)
        if rand(100) < 80
          monster = Actor.new(entities, x, y, "s", "skitterling", "purple")
          hp, defense, power = 10, 0, 3
          monster.combat = Combat.new(monster, hp, defense, power)
          monster.ai = MonsterAI.new(monster)
        else
          monster = Actor.new(entities, x, y, "R", "sentry", "dark grey")
          hp, defense, power = 16, 1, 4
          monster.combat = Combat.new(monster, hp, defense, power)
          monster.ai = MonsterAI.new(monster)
        end
      end
    end
  end

  def self.place_items(room, entities, item_max)
    number_of_items = rand(0..item_max)
    number_of_items.times do
      x, y = *get_xy(room)
      if !spot_occupied?(entities, x, y)
        item = Item.new(entities, x, y, "!", "stimpack", "light blue",
                        "full of [color=light blue]meds.")
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
      x = ((room.r - 1)*(Math.sqrt(r)*Math.cos(theta))).round + room.x
      r = rand(0.0..1.0)
      theta = rand(0.0..6.28)
      y = ((room.r - 1)*(Math.sqrt(r)*Math.sin(theta))).round + room.y
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
