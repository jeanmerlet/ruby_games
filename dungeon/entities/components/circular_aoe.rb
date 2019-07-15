class CircularAOE < Component
  attr_accessor :radius

  def initialize(owner, radius)
    super(owner)
    @radius = radius
  end

  def get_targets(target_x, target_y)
    targets = []
    @owner.entities.each do |entity|
      if entity.combat && entity.distance(target_x, target_y) <= @radius
        targets << entity
      end
    end
    return targets
  end
end
