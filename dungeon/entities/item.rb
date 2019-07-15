class Consumable < Entity
  attr_accessor :components, :effects, :targetting_type

  def initialize(entities, x, y, char, name, color, status)
    super(entities, x, y, char, color, name)
    @render_order = 2
    @blocks, @can_pick_up = false, true
    @status, @effects = status, []
  end

  def use(target)
    results = []
    # target passed is inventory owner if no targetting_type
    targets = (@targetting_type ? get_targets(target) : target)
    @effects.each { |effect| results.push(effect.process(targets)) }
    return results
  end

  def get_targets(target)
    target_x, target_y = target.x, target.y
    return @targetting_type.get_targets(target_x, target_y)
  end
end
