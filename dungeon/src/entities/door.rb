class Door < Entity
  attr_accessor :closed, :locked

  def initialize(entities, x, y, char, name, color)
    super(entities, x, y, char, color, name)
    @render_order = 1
    @blocks, @can_pick_up = true, false
    @closed, @locked = true, false
  end
end
