class Item < Entity
  attr_accessor 

  def initialize(entities, x, y, char, name, color, status, blocks = false)
    super(entities, x, y, char, color, name)
    @blocks = blocks
    @render_order = 2
    @status = status
  end
end
