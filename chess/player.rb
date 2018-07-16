class Player
end

class Human < Player

  def initialize(color)
    @color = color
  end

  def take_turn
    move = 'a2a3'
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
