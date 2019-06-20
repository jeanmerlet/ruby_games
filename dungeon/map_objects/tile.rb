class Tile
  attr_accessor :blocked, :block_sight

  def initialize(blocked)
    @blocked = blocked
    @block_sight = (@blocked == true ? true : false)
    @explored = false
  end
end
