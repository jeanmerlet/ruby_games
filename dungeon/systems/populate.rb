module Populate

  def place_entities(room, entities, monster_max)
    number_of_monsters = rand(0..monster_max)
    number_of_monsters.times do
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
      if !spot_occupied?(x, y, entities)
        if rand(100) < 80
          monster = Entity.new(x, y, "0x108E", "red", 'orc')
        else
          monster = Entity.new(x, y, "0x1073", "dark green", 'troll')
        end
        entities << monster
      end
    end
  end

  def spot_occupied?(x, y, entities)
    entities.each do |entity|
      return true if x == entity.x && y == entity.y
    end
    false
  end
end