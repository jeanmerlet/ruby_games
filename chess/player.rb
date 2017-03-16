class Player

  class Human
    def initialize(color)
      @color = color
    end
  end

  class AI
    def initialize(color, difficulty = normal)
      @color = color
      @difficulty = difficulty
    end
  end

end
