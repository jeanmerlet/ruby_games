class CircularAOE < Component
  attr_accessor :radius

  def initialize(owner, radius)
    super(owner)
    @radius = radius
  end

  def get_targets(target)
    target_x, target_y = target.x, target.y
    targets = []
    @owner.entities.each do |entity|
      if entity.combat && entity.distance(target_x, target_y) <= @radius + 0.5
        targets << entity
      end
    end
    return targets
  end

  def render_target_area(map, fov_id, target)
    x, y = target.x, target.y
    side_length, offset = 2*@radius + 1, @radius
    side_length.times do |i|
      side_length.times do |j|
        cx, cy = x - offset + i, y - offset + j
        if target.distance(cx, cy) <= @radius + 0.5
          BLT.print(2*cx, cy, "[color=darker red][0xE000]")
        end
      end
    end
  end
end
