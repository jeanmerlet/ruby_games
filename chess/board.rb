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
    piece = @spots[origin]
    if piece.is_a?(Pawn)
      if (destination[1] - origin[1]).abs == 2
        piece.double_moved = 1
      else
        piece.double_moved = 0
      end
      if destination[1] == 8 || destination[1] == 1
        @spots[origin] = create_promotion_piece(promotion)
      end
    elsif piece.is_a?(King) || piece.is_a?(Rook)
      piece.has_moved = 1
    end
    @spots[origin], @spots[destination] = 0, @spots[origin]
  end

  def validate_move(player_color, origin, destination)
    piece = @spots[origin]
    return false if piece == 0
    return false if player_color != piece.color
    print piece.generate_moves(@spots, origin)
    return false if !piece.generate_moves(@spots, origin).include?(destination)
    #return false if piece.is_a?(King) && spot_in_check?(player_color, origin)
    true
  end

  def spot_in_check?(player_color, king_spot)
    @spots.each do |spot, piece|
      if @spots[spot] != 0 &&
         @spots[spot].color != player_color &&
         @spots[spot].generate_moves(@spots, spot).include?(king_spot)
        return true
      end
    end
    false
  end

  def find_king(color)
    spot = @spots.find {|spot, piece| piece.is_a?(King) && piece.color == color}[0]
  end

  def can_promote?(origin, destination)
    piece = @spots[origin]
    rank = destination[1]
    return false if !(piece.is_a?(Pawn) && (rank == 8 || rank == 1))
    true
  end

  def create_promotion_piece(player_input)
    piece_type = player_input[0]
    color = player_input[1]
    case piece_type
    when "Q"
      return Queen.new(color)
    when "R"
      return Rook.new(color)
    when "N"
      return Knight.new(color) 
    when "B"
      return Bishop.new(color) 
    end
  end
end

class ChessPiece
  attr_reader :color, :icon, :moves, :letter

  def generate_moves(board, spot)
    legal_spots = []
    @moves.each do |move|
      next_spot = increment_move(spot, move)
      move[2].times do
        break if board[next_spot] == nil
        break if board[next_spot] != 0 && board[next_spot].color == @color
        legal_spots << next_spot
        break if board[next_spot] != 0
        next_spot = increment_move(next_spot, move)
      end
    end
    legal_spots
  end

  def increment_move(spot, move)
    [spot[0] + move[0], spot[1] + move[1]]
  end

  def horizontal_distance(spot_a, spot_b)
    (spot_a[0] - spot_b[0]).abs
  end
end

class Pawn < ChessPiece
  attr_accessor :double_moved

  def initialize(color)
    @color = color
    @double_moved = 0
    @icon = (@color == 'B' ? "\u265F" : "\u2659")
    @letter = ''
    @moves = (@color == 'W' ? [[0, 1, 1],[-1, 1, 1], [1, 1, 1], [0, 2, 1]] :
                              [[0, -1, 1], [-1, -1, 1], [1, -1, 1], [0, -2, 1]])
    @value = 1
  end

  def generate_moves(board, pawn_spot)
    legal_spots = super
    legal_spots.dup.each do |spot|
      x_distance = horizontal_distance(pawn_spot, spot)
      if x_distance == 0 && board[spot] != 0
        legal_spots -= [spot]
      elsif x_distance != 0 && board[spot] == 0
        legal_spots -= [spot] unless can_take_en_passant?(board, pawn_spot, spot)
      end
    end
    legal_spots
  end

  def can_take_en_passant?(board, pawn_spot, destination)
    if @color == 'W'
      target_pawn = board[[destination[0], destination[1] - 1]]
    else
      target_pawn = board[[destination[0], destination[1] + 1]]
    end
    return false if !(target_pawn.is_a?(Pawn) &&
                      target_pawn.color != @color &&
                      target_pawn.double_moved == 1)
    true
  end
end

class Rook < ChessPiece
  attr_accessor :has_moved

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
  attr_accessor :has_moved

  def initialize(color)
    @color = color
    @has_moved = 0
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @letter = 'K'
    @moves = [[0, 1, 1], [1, 1, 1], [1, 0, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 0, 1], [-1, 1, 1], [-4, 0, 1], [3, 0, 1]]
    @value = 10000
  end

  def generate_moves(board, king_spot)
    legal_spots = super
    legal_spots.dup.each do |spot|
      x_distance = horizontal_distance(king_spot, spot)
      if x_distance > 1
        legal_spots -= [spot] unless can_castle?(board, king_spot, spot, x_distance)
      else
        legal_spots -= [spot] if board.spot_in_check?(@color, spot)
      end
    end
    legal_spots
  end

  def can_castle?(board, king_spot, rook_spot, x_distance)
    rook = board.spots[rook_spot]
    return false if @has_moved == 1
    return false if !(rook.is_a?(Rook) && rook.has_moved == 0)

    x = (rook_spot[0] - king_spot[0] > 1 ? -1 : 1)
    (x_distance - 1).times do |i|
      spot = board[[king_spot[0] - (x*(1 + i)), king_spot[1]]]
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
