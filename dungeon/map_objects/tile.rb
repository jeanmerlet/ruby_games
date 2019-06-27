class Tile
  attr_accessor :blocked, :explored

  def initialize(blocked)
    @blocked = blocked
    @explored = false
  end
end
