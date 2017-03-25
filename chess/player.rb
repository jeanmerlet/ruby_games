class Player

  class Human
    attr_accessor :name
    attr_reader :color

    def initialize(color)
      @color = color
      @name = ''
    end

    def input
      puts "Type the square you wish to move a piece from and to. Ex: a1a3 moves whatever is on square a1 to square a3. Type save to save and quit:"
      loop do
        input = gets.chomp
        return input if input =~ /^[a-h][1-8][a-h][1-8]$/
        return input if input == 'save'
        puts 'incorrect format'
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
