class SelfTarget < Component

  def initialize(owner)
    super(owner)
  end

  def get_targets(x, y)
    return [@owner.get_blocking_entity_at(x, y)]
  end

  def render_targetting_grid(x, y)
    BLT.print(2*x, y, "[color=light blue][0xE000]")
  end
end
