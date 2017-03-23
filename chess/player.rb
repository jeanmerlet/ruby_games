class Player

  class Human
    attr_accessor :name
    attr_reader :color

    def initialize(color)
      @color = color
      @name = ''
    end

    def input
      puts "instructions_here"
      input = gets.chomp
    end
  end

  class AI
    def initialize(color, difficulty = normal)
      @color = color
      @difficulty = difficulty
    end
  end

end
