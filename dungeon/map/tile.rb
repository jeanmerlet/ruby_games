class Tile
  attr_accessor :blocked, :explored, :walkable, :entities,
                :bevel_nw, :bevel_ne, :bevel_se, :bevel_sw

  def initialize
    @blocked = true
    @explored = false
    @walkable = false
    @entities = []
    @beveled_nw = false
    @beveled_ne = false
    @beveled_se = false
    @beveled_sw = false
  end
end
