class Item < Entity
  attr_accessor :effects

  def initialize(entities, x, y, char, name, color, status, blocks = false)
    super(entities, x, y, char, color, name)
    @blocks = blocks
    @render_order = 2
    @status = status
    @effects = []
  end

  def do_effects(target)
    results = []
    @effects.each { |effect| results.push(effect.do(target)) }
    return results
  end
end
