class Board

  def initialize
    coordinates = []
    ('a'..'h').to_a.each do |x|
      8.times.with_index { |i| coordinates << x + (i+1).to_s }
    end
    @spots = coordinates.product([0]).to_h
  end

  def create_starting_pieces
  end

  def fill_spots_with_starting_pieces
  end

  def print_board
  end

  class Pawn
    def initialize(color, position)
      @icon = "P"
      @value = 1
      @allowed_moves =
      @color = color
      @position = position
    end
  end

  class Rook
    def initialize(color, position)
      @icon = "R"
      @value = 5
      @allowed_moves =
      @color = color
      @position = position
    end
  end

  class Bishop
    def initialize(color, position)
      @icon = "B"
      @value = 3
      @allowed_moves =
      @color = color
      @position = position
    end
  end

  class Knight
    def initialize(color, position)
      @icon = "N"
      @value = 3
      @allowed_moves =
      @color = color
      @position = position
    end
  end

  class Queen
    def initialize(color, position)
      @icon = "Q"
      @value = 9
      @allowed_moves =
      @color = color
      @position = position
    end
  end

  class King
    def initialize(color, position)
      @icon = "K"
      @value = 10000
      @allowed_moves =
      @color = color
      @position = position
    end
  end

end
