require 'colorize'

class Board
  attr_reader :spots

  def initialize
    #hash with [x, y] coordinate arrays as keys and 0 as default values
    @spots = Hash[[*1..8].repeated_permutation(2).map {|x| [x, 0]}]
  end

  def place_pieces
    @spots.each do |spot, piece|
      if spot[1] == 1
        if spot[0] == 1 || spot[0] == 8
          @spots[spot] = Rook.new('W')
        elsif spot[0] == 2 || spot[0] == 7
          @spots[spot] = Knight.new('W')
        elsif spot[0] == 3 || spot[0] == 6
          @spots[spot] = Bishop.new('W')
        elsif spot[0] == 4
          @spots[spot] = Queen.new('W')
        elsif spot[0] == 5
          @spots[spot] = King.new('W')
        end
      elsif spot[1] == 2
        @spots[spot] = Pawn.new('W')
      elsif spot[1] == 7
        @spots[spot] = Pawn.new('B')
      elsif spot[1] == 8
        if spot[0] == 1 || spot[0] == 8
          @spots[spot] = Rook.new('B')
        elsif spot[0] == 2 || spot[0] == 7
          @spots[spot] = Knight.new('B')
        elsif spot[0] == 3 || spot[0] == 6
          @spots[spot] = Bishop.new('B')
        elsif spot[0] == 4
          @spots[spot] = Queen.new('B')
        elsif spot[0] == 5
          @spots[spot] = King.new('B')
        end
      end
    end
  end

  def render
    print "\n\n"
    8.times do |y|
      print "#{8-y}"
      8.times do |x|
        if ((x%2 == 0) && (y%2 == 0)) || ((x%2 != 0) && (y%2 != 0))
          @spots[[x+1, 8-y]] == 0 ?
          (print "   ".on_white) :
          (print " #{@spots[[x+1, 8-y]].icon} ".black.on_white)
        else
          @spots[[x+1, 8-y]] == 0 ?
          (print "   ".on_light_black) :
          (print " #{@spots[[x+1, 8-y]].icon} ".black.on_light_black)
        end
      end
      print "\n"
    end
    print "  a  b  c  d  e  f  g  h\n\n"
  end

  def update(origin, destination, promotion)
    piece = @board[origin]
    if piece.is_a?(Pawn)
      if (destination[1] - origin[1]).abs == 2
        piece.double_moved = 1 
      else
        piece.double_moved = 0
      end
      piece.moves.pop if piece.moves.size == 4
      @board[origin] = promotion if destination[1] == 8 || destination[1] == 1
    elsif piece.is_a?(King) || piece.is_a?(Rook)
      piece.has_moved = 1
    end
    @spots[origin], @spots[destination] = 0, @spots[origin]
  end

  def validate_move(player_color, origin, destination)
    piece = @board[origin]
    return false if piece == 0
    return false if player_color != piece.color
    return false if !piece.generate_moves(@spots, origin).include?(destination)
    return false if piece.is_a?(King) && spot_in_check?(player_color, origin)
    true
  end

  def spot_in_check?(player_color, king_spot)
    checking_color = (player_color == 'W' ? 'B' : 'W')
    @spots.each do |spot, piece|
      if @spots[spot] != 0 &&
         @spots[spot].color == checking_color &&
         @spots[spot].generate_moves(board, spot).include?(king_spot)
        return true
      end
    end
    false
  end

  def find_king(color)
    spot = @spots.find {|spot, piece| piece.is_a?(King) && piece.color == color}[0]
  end

  def promotion_available?(origin, destination)
    piece = board[origin]
    rank = destination[1]
    return false if !(piece.is_a?(Pawn) && (rank == 8 || rank == 1))
    true
  end
end

class ChessPiece
  attr_reader :color, :icon, :moves, :letter

  def generate_moves(board, spot)
    moves = []
    @moves.each do |move|
      next_spot = increment_move(spot, move)
      move[2].times do
        break if board[next_spot] == nil
        break if board[next_spot] != 0 && board[next_spot].color == @color
        moves << next_spot
        break if board[next_spot] != 0
        next_spot = increment_move(next_spot, move)
      end
    end
    moves
  end

  def increment_move(spot, move)
    next_spot = [spot[0] + move[0], spot[1] + move[1]]
  end

  def horizontal_distance(spot_a, spot_b)
    (spot_a[0] - spot_b[0]).abs
  end
end

class Pawn < ChessPiece
  attr_accessor :moves, :en_passable

  def initialize(color)
    @color = color
    @double_moved = 0
    @icon = (@color == 'B' ? "\u265F" : "\u2659")
    @letter = ''
    @moves = (@color == 'W' ? [[0, 1, 1],[-1, 1, 1], [1, 1, 1], [0, 2, 1]] :
                              [[0, -1, 1], [-1, -1, 1], [1, -1, 1], [0, -2, 1]])
    @value = 1
  end

  def generate_moves(board, spot)
    moves = super
      moves.dup.each do |move|
        x_distance = move[0]
        destination = increment_move(spot, move)
        target_spot = board[destination]
        if x_distance == 0 && target_spot != 0
          moves -= [move]
        elsif target_spot == 0
          
          moves -= [move] unless can_take_en_passant?(board, spot, destination)
      end
    end
    moves
  end

  def can_take_en_passant?(board, origin, destination)
    if @color == 'W'
      pawn = board[[destination[0], destination[1] - 1]]
    else
      pawn = board[[destination[0], destination[1] + 1]]
    end
    return false if !(pawn.is_a?(Pawn) &&
                      pawn.color != @color &&
                      pawn.double_moved == 1)
    true
  end
end

class Rook < ChessPiece
  attr_accessor :castle

  def initialize(color)
    @color = color
    @has_moved = 0
    @icon = (@color == 'B' ? "\u265C" : "\u2656")
    @letter = 'R'
    @moves = [[0, 1, 7], [0, -1, 7], [-1, 0, 7], [1, 0, 7]]
    @value = 5
  end
end

class Knight < ChessPiece

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265E" : "\u2658")
    @letter = 'N'
    @moves = [[1, 2, 1], [1, -2, 1], [-1, 2, 1], [-1, -2, 1], [2, 1, 1], [2, -1, 1], [-2, 1, 1], [-2, -1, 1]]
    @value = 3
  end
end

class Bishop < ChessPiece

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265D" : "\u2657")
    @letter = 'B'
    @moves = [[1, 1, 7], [1, -1, 7], [-1, 1, 7], [-1, -1, 7]]
    @value = 3
  end
end

class King < ChessPiece
  attr_accessor :castle

  def initialize(color)
    @color = color
    @has_moved = 0
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @letter = 'K'
    @moves = [[0, 1, 1], [1, 1, 1], [1, 0, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 0, 1], [-1, 1, 1], [-4, 0, 1], [3, 0, 1]]
    @value = 10000
  end

  def generate_moves(board, king_spot)
    moves = super
    moves.dup.each do |move|
      x_distance = move[0].abs
      if x_distance > 1
        rook = board.spots[increment_move(king_spot, move)]
        moves -= [move] unless can_castle?(board, king_spot, rook, x_distance)
      end
    end
    true
  end

  def can_castle?(board, king_spot, rook, spot_number)
    return false if @has_moved == 1
    return false if !(rook.is_a?(Rook) && rook.has_moved == 0)

    (spot_number - 1).times do |i|
      spot = board[[[king_spot[0] - 1 - i], king_spot[1]]]
      if spot != 0
        return false
      elsif board.spot_in_check?(@color, spot)
        return false
      end
    end
    true
  end
end

class Queen < ChessPiece

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265B" : "\u2655")
    @letter = 'Q'
    @moves = [[0, 1, 7], [1, 1, 7], [1, 0, 7], [1, -1, 7], [0, -1, 7], [-1, -1, 7], [-1, 0, 7], [-1, 1, 7]]
    @value = 10
  end
end
