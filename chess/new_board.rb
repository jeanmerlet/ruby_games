require 'colorize'

class Board

  def initialize
    @letters = ('a'...'h').to_a
    @board = []
    coordinates = [*1..8].repeated_permutation(2).to_a
    coordinates.each do |i|
      @board << [i, '']
    end
  end

  def place_pieces
    @board.each do |spot|
      if spot[0][1] == 2 || spot[0][1] == 7          #pawns
        spot[1] = Pawn.new(spot[0])
      elsif spot[0][1] == 1 || spot[0][1] == 8       #other pieces
        if spot[0][0] == 1 || spot[0][0] == 8
          spot[1] = Rook.new(spot[0])
        elsif spot[0][0] == 2 || spot[0][0] == 7
          spot[1] = Knight.new(spot[0])
        elsif spot[0][0] == 3 || spot[0][0] == 6
          spot[1] = Bishop.new(spot[0][0])
        elsif spot[0][0] == 4
          spot[1] = Queen.new(spot[0][0])
        elsif spot[0][0] == 5
          spot[1] = King.new(spot[0][0])
        else
          spot[1] = 'empty'
        end
      end
      if spot[0][0] == 1 || spot[0][0] == 2         #coloring
        spot[1].color = 'W'
      else
        spot[1].color = 'B'
      end
    end
  end

  def render
    print "\n\n"

    8.times do |x|
      number = 8-x
      print "#{number} "
      8.times do |y|
        spot = [(x+1), (y+1)]
        if ((x % 2 == 0) && (y % 2 == 0)) || ((x % 2 != 0) && (y % 2 != 0))
          @board[(x+y)][1] == "empty" ?
          (print " ".on_white) : (print "#{@board[(x+y)][1].icon}".black.on_white)
        else
          @board[(x+y)][1] == "empty" ?
          (print " ".on_light_black) : (print "#{@board[(x+y)][1].icon}".black.on_light_black)
        end
      end
    end
    print "\n"
    print "   abcdefgh\n\n"
  end

  def update(move)
  end
end

class ChessPiece

  def generate_moves
  end

end

class Pawn < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end

class Rook < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end

class Knight < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end

class Bishop < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end

class King < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end

class Queen < ChessPiece
  def initialize(coordinates)
    @color = 'blank'
    @coordinates = coordinates
    @icon = 'pawn'
  end
end
