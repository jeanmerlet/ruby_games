require 'colorize'


class Board
  attr_reader :board

  def initialize
    #hash with [x, y] coordinate arrays as keys and 0 as default values
    @board = Hash[[*1..8].repeated_permutation(2).map {|x| [x, 0]}]
  end

  def place_pieces
    @board.each do |spot, piece|
      if spot[1] == 1
        if spot[0] == 1 || spot[0] == 8
          piece = Rook.new('W')
        elsif spot[0] == 2 || spot[0] == 7
          piece = Knight.new('W')
        elsif spot[0] == 3 || spot[0] == 6
          piece = Bishop.new('W')
        elsif spot[0] == 4
          piece = Queen.new('W')
        elsif spot[0] == 5
          piece = King.new('W')
        end
      elsif spot[1] == 2
        piece = Pawn.new('W')
      elsif spot[1] == 7
        piece = Pawn.new('B')
      elsif spot[1] == 8
        if spot[0] == 1 || spot[0] == 8
          piece = Rook.new('B')
        elsif spot[0] == 2 || spot[0] == 7
          piece = Knight.new('B')
        elsif spot[0] == 3 || spot[0] == 6
          piece = Bishop.new('B')
        elsif spot[0] == 4
          piece = Queen.new('B')
        elsif spot[0] == 5
          piece = King.new('B')
        end
      end
    end
  end

  def render
    print "\n\n"

    8.times do |y|
      number = 8-y
      print "#{number} "
      8.times do |x|
        if ((x % 2 == 0) && (y % 2 == 0)) || ((x % 2 != 0) && (y % 2 != 0))
          @board[[x, y]] == 0 ?
          (print " ".on_white) : (print "#{@board[[x,y]].icon}".black.on_white)
        else
          @board[[x, y]] == 0 ?
          (print " ".on_light_black) : (print "#{@board[[x,y]].icon}".black.on_light_black)
        end
      end
      print "\n"
    end
    print "  abcdefgh\n\n"
  end

  def update(move)
  end
end

class ChessPiece

  def generate_moves
  end

end

class Pawn < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2659" : "\u265F")
  end
end

class Rook < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2656" : "\u265C")
  end
end

class Knight < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2658" : "\u265E")
  end
end

class Bishop < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2657" : "\u265D")
  end
end

class King < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2654" : "\u265A")
  end
end

class Queen < ChessPiece
  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u2655" : "\u265B")
  end
end


test = Board.new
test.place_pieces
print test.board
