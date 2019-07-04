class Tile
  attr_accessor :blocked, :explored, :bevel_nw, :bevel_ne, :bevel_se, :bevel_sw

  def initialize(blocked)
    @blocked = blocked
    @explored = false
    @beveled_nw = false
    @beveled_ne = false
    @beveled_se = false
    @beveled_sw = false
  end
end
