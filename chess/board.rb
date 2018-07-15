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
          @board[spot] = Rook.new('W')
        elsif spot[0] == 2 || spot[0] == 7
          @board[spot] = Knight.new('W')
        elsif spot[0] == 3 || spot[0] == 6
          @board[spot] = Bishop.new('W')
        elsif spot[0] == 4
          @board[spot] = Queen.new('W')
        elsif spot[0] == 5
          @board[spot] = King.new('W')
        end
      elsif spot[1] == 2
        @board[spot] = Pawn.new('W')
      elsif spot[1] == 7
        @board[spot] = Pawn.new('B')
      elsif spot[1] == 8
        if spot[0] == 1 || spot[0] == 8
          @board[spot] = Rook.new('B')
        elsif spot[0] == 2 || spot[0] == 7
          @board[spot] = Knight.new('B')
        elsif spot[0] == 3 || spot[0] == 6
          @board[spot] = Bishop.new('B')
        elsif spot[0] == 4
          @board[spot] = Queen.new('B')
        elsif spot[0] == 5
          @board[spot] = King.new('B')
        end
      end
    end
  end

  def render
    print "\n\n"

    8.times do |y|
      number = 8-y
      print "#{number}"
      8.times do |x|
        if ((x % 2 == 0) && (y % 2 == 0)) || ((x % 2 != 0) && (y % 2 != 0))
          @board[[x+1, y+1]] == 0 ?
          (print " ".on_white) : (print "#{@board[[x+1,y+1]].icon}".black.on_white)
        else
          @board[[x+1, y+1]] == 0 ?
          (print " ".on_light_black) : (print "#{@board[[x+1,y+1]].icon}".black.on_light_black)
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
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265F" : "\u2659")
  end
end

class Rook < ChessPiece
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265C" : "\u2656")
  end
end

class Knight < ChessPiece
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265E" : "\u2658")
  end
end

class Bishop < ChessPiece
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265D" : "\u2657")
  end
end

class King < ChessPiece
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265A" : "\u2654")
  end
end

class Queen < ChessPiece
attr_reader :color, :icon

  def initialize(color)
    @color = color
    @icon = (@color == 'W' ? "\u265B" : "\u2655")
  end
end
