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
        #print [x+1, 8-y]
        if ((x%2 == 0) && (y%2 == 0)) || ((x%2 != 0) && (y%2 != 0))
          @board[[x+1, 8-y]] == 0 ?
          (print " ".on_white) :
          (print "#{@board[[x+1, 8-y]].icon}".black.on_white)
        else
          @board[[x+1, 8-y]] == 0 ?
          (print " ".on_light_black) :
          (print "#{@board[[x+1, 8-y]].icon}".black.on_light_black)
        end
      end
      print "\n"
    end
    print " abcdefgh\n\n"
  end

  def update(origin, destination)
    if @board[origin].is_a?(Pawn) && @board[origin].moves.size == 4
      @board[origin].moves.pop
    end
    if @board[origin].is_a?(King) || @board[origin].is_a?(Rook)
      @board[origin].can_castle = 0
    end
    @board[origin], @board[destination] = 0, @board[origin]
  end

  def validate_move(color, origin, destination)
    return false if @board[origin] == 0
    return false if color != @board[origin].color
    return false unless generate_moves(color, origin).include?(destination)
    true
  end

  def generate_moves(color, spot)
    valid_moves = []
    @board[spot].moves.each do |move|
      next_spot = calculate_next_spot(spot, move)
      move[2].times do
        break if @board[next_spot] == nil
        break if @board[next_spot] != 0 && @board[next_spot].color == color
        valid_moves << next_spot
        break if @board[next_spot] != 0
        next_spot = calculate_next_spot(next_spot, move)
      end
    end
    valid_moves
  end

  def calculate_next_spot(spot, move)
    next_spot = [spot[0] + move[0], spot[1] + move[1]]
  end

  def check?(color, king_spot)
    color = (color == 'W' ? 'B' : 'W')
    @board.each do |spot, piece|
      if @board[spot] != 0 && @board[spot].color == color &&
         generate_moves(color, spot).include?(king_spot)
        return true
      end
    end
    false
  end

  def find_king(color)
    spot = @board.find {|spot, piece| piece.is_a?(King) && piece.color == color}[0]
  end
end

class ChessPiece
end

class Pawn < ChessPiece
  attr_reader :color, :icon
  attr_accessor :moves

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265F" : "\u2659")
    @moves = (@color == 'W' ? [[0, 1, 1],[-1, 1, 1], [1, 1, 1], [0, 2, 1]] :
                              [[0, -1, 1], [-1, -1, 1], [1, -1, 1], [0, -2, 1]])
  end
end

class Rook < ChessPiece
  attr_reader :color, :icon, :moves
  attr_accessor :can_castle

  def initialize(color)
    @color = color
    @can_castle = 1
    @icon = (@color == 'B' ? "\u265C" : "\u2656")
    @moves = [[0, 1, 7], [0, -1, 7], [-1, 0, 7], [1, 0, 7]]
  end
end

class Knight < ChessPiece
  attr_reader :color, :icon, :moves

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265E" : "\u2658")
    @moves = [[1, 2, 1], [1, -2, 1], [-1, 2, 1], [-1, -2, 1], [2, 1, 1], [2, -1, 1], [-2, 1, 1], [-2, -1, 1]]
  end
end

class Bishop < ChessPiece
  attr_reader :color, :icon, :moves

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265D" : "\u2657")
    @moves = [[1, 1, 7], [1, -1, 7], [-1, 1, 7], [-1, -1, 7]]
  end
end

class King < ChessPiece
  attr_reader :color, :icon, :moves
  attr_accessor :can_castle

  def initialize(color)
    @color = color
    @can_castle = 1
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @moves = [[0, 1, 1], [1, 1, 1], [1, 0, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 0, 1], [-1, 1, 1]]
  end
end

class Queen < ChessPiece
  attr_reader :color, :icon, :moves

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265B" : "\u2655")
    @moves = [[0, 1, 7], [1, 1, 7], [1, 0, 7], [1, -1, 7], [0, -1, 7], [-1, -1, 7], [-1, 0, 7], [-1, 1, 7]]
  end
end
