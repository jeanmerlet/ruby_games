class Tile
  attr_accessor :blocked, :explored, :passable, :entities,
                :bevel_nw, :bevel_ne, :bevel_se, :bevel_sw

  def initialize
    @blocked, @explored, @passable = true, false, false
    @entities = []
    @beveled_nw = false
    @beveled_ne = false
    @beveled_se = false
    @beveled_sw = false
  end

  def add_entity(entity)
    @entities << entity
    @entities.sort! { |a, b| b.render_order <=> a.render_order }
  end

  def remove_entity(entity)
    @entities.delete(entity)
  end
end
