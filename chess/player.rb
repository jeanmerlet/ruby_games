class Player

  class Human
    attr_accessor :name
    attr_reader :color

    def initialize(color)
      @color = color
      @name = ''
    end

    def input
      loop do
        puts "Type the square you wish to move a piece from and to. Ex: a1a3 moves whatever is on square a1 to square a3. Type save to save and quit:"
        input = gets.chomp
        return input if gets.chomp == /^[a-h][1-8][a-h][1-8]$/ || 'save'
      end
    end
  end

  class AI
    def initialize(color, difficulty = normal)
      @color = color
      @difficulty = difficulty
    end
  end

end
