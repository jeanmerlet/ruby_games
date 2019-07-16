class Consumable < Entity
  attr_accessor :components, :effects, :targetting, :messages

  def initialize(entities, x, y, char, name, color)
    super(entities, x, y, char, color, name)
    @render_order = 2
    @blocks = false
    @effects, @messages = [], []
  end

  def use(target)
    results = []
    # target passed is inventory owner if targetting is nil
    targets = (@targetting ? @targetting.get_targets(target) : target)
    @effects.each.with_index { |effect, i| results.push(effect.process(targets, i)) }
    return results
  end
end
