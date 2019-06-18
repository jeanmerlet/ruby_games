class Tile

  def initialize(blocked, block_sight = false)
    @blocked = blocked
    @block_sight = block_sight
    @block_sight = true if @blocked
  end

  class Wall < Tile
    def initialize
      super
      @char = "#"
    end
  end

  class Floor < Tile
    def initialize
      super
      @char = "."
    end
  end
end
