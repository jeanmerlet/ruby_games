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

  def update(origin, destination)
=begin
    if @board[origin].is_a?(Pawn)
      if @board[origin].moves.size == 4
        if (destination[1] - origin[1]).abs == 2
          left_side = @board[[destination[0] - 1, destination[1]]]
          right_side = @board[[destination[0] + 1, destination[1]]]
          if (left_side.is_a?(Pawn) && left_side.color != @board[origin].color) ||
             (right_side.is_a?(Pawn) && right_side.color != @board[origin].color)
            @board[origin].en_passant = 1
          end
        end
        @board[origin].moves.pop
      end
      #@board[origin] = promotion if destination[1] == 8 || destination[1] == 1
    end
    if @board[origin].is_a?(King) || @board[origin].is_a?(Rook)
      @board[origin].castle = 0
    end
=end
    @spots[origin], @spots[destination] = 0, @spots[origin]
  end

  def validate_move(color, origin, destination)
    return false if @board[origin] == 0
    return false if color != @board[origin].color
    return false unless generate_moves(color, origin).include?(destination)

    if @board[origin].is_a?(Pawn)
      return false unless validate_pawn_move(color, origin, destination)
    elsif @board[origin].is_a?(King)
      return false unless validate_king_move(color, origin, destination)
    end

    true
  end

  def validate_pawn_move(color, origin, destination)
    x_distance = horizontal_distance(origin, destination)
    return false if x_distance == 0 && @board[destination] != 0
    if x_distance == 1 && @board[destination] == 0
      if color == 'W'
        target_pawn_spot = [destination[0], destination[1] - 1]
      else
        target_pawn_spot = [destination[0], destination[1] + 1]
      end
      target_pawn = @board[target_pawn_spot]
      if target_pawn.is_a?(Pawn) &&
         target_pawn.color != color &&
         target_pawn.en_passant == 1
        @board[target_pawn_spot] = 0
      else
        return false
      end
    end
    true
  end

  def validate_king_move(color, origin, destination)
    return false if check?(color, destination)
    x_distance = horizontal_distance(origin, destination)
    if x_distance > 1
      return false unless @board[origin].castle == 1
      return false unless @board[destination].is_a?(Rook) &&
                          @board[destination].castle == 1
      (x_distance - 1).times do |i|
        return false if !@board[[[origin[0] - 1 - i], origin[1]]] == 0 &&
                        check?(color, @board[[origin[0] - 1 - i], origin[1]])
      end
    else
      return false if @board[destination] != 0 && @board[destination].color == color
    end
    true
  end

  def generate_moves(color, spot)
    valid_moves = []
    @spots[spot].moves.each do |move|
      next_spot = calculate_next_spot(spot, move)
      move[2].times do
        break if @spots[next_spot] == nil
        break if @spots[next_spot] != 0 && @spots[next_spot].color == color unless
                 @spots[spot].is_a?(King)
        valid_moves << next_spot
        break if @spots[next_spot] != 0
        next_spot = calculate_next_spot(next_spot, move)
      end
    end
    valid_moves
  end

  def calculate_next_spot(spot, move)
    next_spot = [spot[0] + move[0], spot[1] + move[1]]
  end

  def horizontal_distance(spot_a, spot_b)
    (spot_a[0] - spot_b[0]).abs
  end

  def check?(color, king_spot)
    color = (color == 'W' ? 'B' : 'W')
    @spots.each do |spot, piece|
      if @spots[spot] != 0 && @spots[spot].color == color &&
         generate_moves(color, spot).include?(king_spot)
        return true
      end
    end
    false
  end

  def find_king(color)
    spot = @spots.find {|spot, piece| piece.is_a?(King) && piece.color == color}[0]
  end
end

class ChessPiece
  attr_reader :color, :icon, :moves, :letter

  def validate_move(player_color, board, origin, destination)
    return false if board[origin] == 0
    return false if player_color != @color
    return false unless generate_moves(board, origin).include?(destination)
    true
  end

  def generate_moves(board, spot)
    valid_moves = []
    @moves.each do |move|
      next_spot = calculate_next_spot(spot, move)
      move[2].times do
        break if board[next_spot] == nil
        break if board[next_spot] != 0 && board[next_spot].color == @color
        valid_moves << next_spot
        break if board[next_spot] != 0
        next_spot = calculate_next_spot(next_spot, move)
      end
    end
    valid_moves
  end

  def calculate_next_spot(spot, move)
    next_spot = [spot[0] + move[0], spot[1] + move[1]]
  end

  def horizontal_distance(spot_a, spot_b)
    (spot_a[0] - spot_b[0]).abs
  end
end

class Pawn < ChessPiece
  attr_accessor :moves, :en_passant

  def initialize(color)
    @color = color
    @en_passant = 0
    @icon = (@color == 'B' ? "\u265F" : "\u2659")
    @letter = ''
    @moves = (@color == 'W' ? [[0, 1, 1],[-1, 1, 1], [1, 1, 1], [0, 2, 1]] :
                              [[0, -1, 1], [-1, -1, 1], [1, -1, 1], [0, -2, 1]])
    @value = 1
  end

  def validate_move(player_color, board, origin, destination)
    if super
      x_distance = horizontal_distance(origin, destination)
      return false if x_distance == 0 && board[destination] != 0
      if x_distance == 1 && @board[destination] == 0
        if color == 'W'
          target_pawn_spot = [destination[0], destination[1] - 1]
        else
          target_pawn_spot = [destination[0], destination[1] + 1]
        end
        target_pawn = @board[target_pawn_spot]
        if target_pawn.is_a?(Pawn) &&
           target_pawn.color != color &&
           target_pawn.en_passant == 1
          @board[target_pawn_spot] = 0
        else
          return false
        end
      end
      true
    end
  end
end

class Rook < ChessPiece
  attr_accessor :castle

  def initialize(color)
    @color = color
    @castle = 1
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
    @castle = 1
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @letter = 'K'
    @moves = [[0, 1, 1], [1, 1, 1], [1, 0, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 0, 1], [-1, 1, 1], [-4, 0, 1], [3, 0, 1]]
    @value = 10000
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
