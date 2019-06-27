class Tile
  attr_accessor :blocked, :block_sight, :explored

  def initialize(blocked)
    @blocked = blocked
    @explored = false
  end
end
