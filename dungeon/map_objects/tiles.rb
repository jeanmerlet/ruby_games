class Tile
  attr_accessor :blocked, :block_sight

  def initialize(blocked, block_sight = false)
    @blocked = blocked
    @block_sight = block_sight
    @block_sight = true if @blocked
  end
end
