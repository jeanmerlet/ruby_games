class Board

  def initialize
    coordinates = []
    ('a'..'h').to_a.each do |x|
      8.times.with_index { |i| coordinates << x + (i+1).to_s }
    end
    @spots = coordinates.product([0]).to_h
  end

  def populate_spots
    @spots.each_pair do |spot, piece|
      if spot ~= /[2, 7]/         then piece = Pawn.new
      elsif spot ~= /[1,8]/
        if spot ~= /[a, h]/       then piece = Rook.new
        elsif spot ~= /[b, g]/    then piece = Night.new
        elsif spot ~= /[c, f]/    then piece = Bishop.new
        elsif spot ~= /[d1, e8]/  then piece = Queen.new
        elsif spot ~= /[e1, d8]/  then piece = King.new
        end
      else
        piece = 'none'
      end
    end
    @spots.values do |piece|
      if piece ~= /[7, 8]/ then piece.color = 'black'
      elsif piece ~= /[1, 2]/ then piece.color = 'white'
      end
    end
  end

  def print_board
  end

  class Pawn
    def initialize
      @icon = "P"
      @value = 1
      @allowed_moves =
      @color = ''
    end
  end

  class Rook
    def initialize
      @icon = "R"
      @value = 5
      @allowed_moves =
      @color = ''
    end
  end

  class Bishop
    def initialize
      @icon = "B"
      @value = 3
      @allowed_moves =
      @color = ''
    end
  end

  class Knight
    def initialize
      @icon = "N"
      @value = 3
      @allowed_moves =
      @color = ''
    end
  end

  class Queen
    def initialize
      @icon = "Q"
      @value = 9
      @allowed_moves =
      @color = ''
    end
  end

  class King
    def initialize
      @icon = "K"
      @value = 10000
      @allowed_moves =
      @color = ''
    end
  end

end
