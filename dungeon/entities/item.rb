class Consumable < Entity
  attr_accessor :components, :effects, :targetting

  def initialize(entities, x, y, char, name, color, status)
    super(entities, x, y, char, color, name)
    @render_order = 2
    @blocks, @can_pick_up = false, true
    @status, @effects = status, []
  end

  def use(target)
    results = []
    # target passed is inventory owner if targetting is nil
    targets = (@targetting ? @targetting.get_targets(target) : target)
    @effects.each { |effect| results.push(effect.process(targets)) }
    return results
  end
end
