class Consumable < Entity
  attr_accessor :components, :effects, :targetting, :messages

  def initialize(entities, x, y, char, name, color)
    super(entities, x, y, char, color, name)
    @render_order = 2
    @blocks, @can_pick_up = false, true
    @effects, @messages = [], []
  end

  def use(x, y)
    results = []
    # target passed is inventory owner if targetting is nil
    targets = (@targetting ? @targetting.get_targets(x, y) : target)
    @effects.each.with_index { |effect, i| results.push(effect.process(targets, i)) }
    return results
  end
end
