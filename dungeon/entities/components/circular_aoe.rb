class CircularAOE < Component
  attr_accessor :radius

  def initialize(owner, radius)
    super(owner)
    @radius = radius
  end

  def get_targets(center_x, center_y)
    targets = []
    @owner.entities.each do |entity|
      if entity.combat && entity.distance_to(center_x, center_y) <= @radius + 0.5
        targets << entity
      end
    end
    return targets
  end

  def render_target_area(center_x, center_y)
    side_length, offset = 2*@radius + 1, @radius
    side_length.times do |i|
      side_length.times do |j|
        current_x, current_y = center_x - offset + i, center_y - offset + j
        if distance(center_x, center_y, current_x, current_y) <= @radius + 0.5
          BLT.print(2*current_x, current_y, "[color=darker red][0xE000]")
        end
      end
    end
  end

  def distance(x1, y1, x2, y2)
    Math.sqrt((x1-x2)**2 + (y1-y2)**2)
  end
end
