class Player
  attr_reader :color
end

class Human < Player

  def initialize(color)
    @color = color
  end

  def take_turn
    gets.chomp
  end

  def pawn_promote
    gets.chomp
  end
end

class AI < Player

  def initialize(color)
    @color = color
    @difficulty = 0
  end

  def take_turn
  end

  def pawn_promote
  end
end
