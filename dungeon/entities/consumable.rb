class Consumable < Entity
  attr_accessor :effects, :targetting, :messages

  def initialize(entities, x, y, char, name, color)
    super(entities, x, y, char, color, name)
    @render_order = 2
    @blocks, @can_pick_up = false, true
    @effects, @messages = [], []
  end

  def use(target_x, target_y)
    results = []
    targets = @targetting.get_targets(target_x, target_y)
    @effects.each.with_index do |effect, i|
      results.push(effect.process(targets, i))
    end
    return results
  end
end
