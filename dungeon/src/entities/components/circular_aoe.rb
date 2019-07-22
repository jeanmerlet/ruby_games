class CircularAOE < Component
  attr_reader :max_range

  def initialize(owner, radius, max_range)
    super(owner)
    @radius, @max_range = radius, max_range + 0.5
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

  def render_targetting_grid(center_x, center_y)
    side_length, offset = 2*@radius + 1, @radius
    side_length.times do |i|
      side_length.times do |j|
        current_x, current_y = center_x - offset + i, center_y - offset + j
        if owner.dist(center_x, center_y, current_x, current_y) <= @radius + 0.5
          BLT.print(2*current_x, current_y, "[color=darker red][0xE000]")
        end
      end
    end
  end
end
