class Player
end

class Human < Player
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def take_turn
    input = gets
  end
end

class AI < Player

  def initialize(color)
    @color = color
    @difficulty = 0
  end

  def take_turn
  end
end
