require 'colorize'

class Board
  attr_accessor :spots, :promotion
  attr_reader   :undo, :castle_undo, :en_passant_undo

  def initialize
    #hash with [x, y] coordinate arrays as keys and 0 as default values
    @spots = Hash[[*1..8].repeated_permutation(2).map {|x| [x, 0]}]
    @promotion = false
    @undo = []
    @castle_undo = []
    @en_passant_undo = []
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
    print "\n"
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

  def update(round, player, origin, destination, logger = false)
    piece = @spots[origin]
    if piece.is_a?(Pawn)
      pawn_update(piece, origin, destination, logger)
    elsif piece.is_a?(King)
      castle_update(piece, origin, destination, logger)
    elsif piece.is_a?(Rook)
      piece.has_moved = true if logger
    end
    if logger
      logger.record_move(self, round, player, origin, destination)
    else
      @undo = [[origin.dup, @spots[origin].dup], [destination.dup, @spots[destination].dup]]
    end
    @spots[origin], @spots[destination] = 0, @spots[origin]
  end

  def pawn_update(piece, origin, destination, logger)
    if (destination[1] - origin[1]).abs == 2
      piece.en_passable = true
    else
      if piece.horizontal_distance(origin, destination) == 1 &&
         @spots[destination] == 0
        if piece.color == 'W'
          passed_pawn_spot = [destination[0], destination[1] - 1]
        else
          passed_pawn_spot = [destination[0], destination[1] + 1]
        end
        if logger
          logger.tokens[:en_passant] = true
        else
          @en_passant_undo = [true, passed_pawn_spot.dup, @spots[passed_pawn_spot].dup]
        end
        @spots[passed_pawn_spot] = 0
      end
    end
    if @promotion && logger
      @spots[origin] = create_promotion_piece
      @promotion = false
    end
    piece.move_steps[0][2] = 1 if logger
  end

  def castle_update(king, origin, destination, logger)
    if king.horizontal_distance(origin, destination) > 1
      rook_origin, rook_destination = destination.dup, destination.dup
      if destination[0] == 3
        rook_origin[0] = 1
        rook_destination[0] = 4
        logger.tokens[:castle] = "O-O-O" if logger
      else
        rook_origin[0] = 8
        rook_destination[0] = 6
        logger.tokens[:castle] = "O-O" if logger
      end
      @castle_undo = [true, rook_origin.dup, rook_destination.dup] if !logger
      @spots[rook_origin], @spots[rook_destination] = 0, @spots[rook_origin]
    end
    2.times {king.move_steps.pop} if king.move_steps.size == 10 && logger
  end

  def process_undos
    piece = @undo[0][1]
    piece.en_passable = false if piece.is_a?(Pawn) && piece.en_passable
    if @en_passant_undo[0]
      @spots[@en_passant_undo[1]] = @en_passant_undo[2]
    end
    if @castle_undo[0]
      @spots[@castle_undo[1]], @spots[@castle_undo[2]] = @spots[@castle_undo[2]], 0
    end
    @spots[@undo[0][0]], @spots[@undo[1][0]] = @undo[0][1], @undo[1][1]
    undo_reset
  end

  def undo_reset
    @undo = []
    @en_passant_undo = [false]
    @castle_undo = [false]
  end

  def validate_move(player_color, origin, destination)
    piece = @spots[origin]
    return false if piece == 0
    return false if player_color != piece.color
    return false if !piece.generate_moves(self, origin).include?(destination)
    true
  end

  def spot_in_check?(color, target_spot)
    @spots.each do |spot, piece|
      piece = @spots[spot]
      if piece != 0 && piece.color != color &&
         piece.generate_moves(self, spot, false).include?(target_spot)
        return true if !(piece.is_a?(Pawn) && spot[0] == target_spot[0])
      end
    end
    false
  end

  def find_king(color)
    @spots.find {|spot, piece| piece.is_a?(King) && piece.color == color}.first
  end

  def find_SAN_piece(piece_type, color, origin_SAN, destination)
    matches = @spots.select do |spot, piece|
      @spots[spot] != 0 &&
      @spots[spot].letter == piece_type &&
      @spots[spot].color == color &&
      @spots[spot].generate_moves(self, spot).include?(destination)
    end.keys
    print matches
    if matches.size == 1
      return matches.first
    else
      matches.each do |spot|
        if /\A[a-h]\z/ === origin_SAN
          return spot if (@@letter_index.index(origin_SAN) + 1).to_i == spot[0]
        elsif /\A[1-8]\z/ === origin_SAN
          return spot if origin_SAN.to_i == spot[1]
        elsif (@@letter_index.index(origin_SAN) + 1).to_i == spot[0] &&
              origin_SAN.to_i == spot[1]
          return spot
        end
      end
    end
  end

  def need_promote?(origin, destination)
    piece = @spots[origin]
    rank = destination[1]
    return false if !(piece.is_a?(Pawn) && (rank == 8 || rank == 1))
    true
  end

  def create_promotion_piece
    piece_type = @promotion[0]
    color = @promotion[1]
    promotion = case piece_type
    when "Q" then Queen.new(color)
    when "R" then Rook.new(color)
    when "N" then Knight.new(color) 
    when "B" then Bishop.new(color) 
    end
    promotion
  end
end

class ChessPiece
  attr_reader :color, :icon, :move_steps, :letter

  def generate_moves(board, origin, check_for_check = true)
    spots = board.spots
    moves = []
    king_spot = board.find_king(@color) if check_for_check
    @move_steps.each do |move_step|
      move = increment_move(origin, move_step)
      move_step[2].times do
        break if spots[move] == nil
        break if spots[move] != 0 && spots[move].color == @color
        if !self.is_a?(King) && check_for_check &&
           moving_self_checks(board, origin, move, king_spot)
          break if spots[move] != 0
          move = increment_move(move, move_step)
          next
        end
        moves << move
        break if spots[move] != 0
        move = increment_move(move, move_step)
      end
    end
    moves
  end

  def moving_self_checks(board, origin, move, king_spot)
    undo = [board.spots[origin].dup, board.spots[move].dup]
    board.spots[origin], board.spots[move] = 0, board.spots[origin]
    if board.spot_in_check?(@color, king_spot)
      board.spots[origin], board.spots[move] = undo[0], undo[1]
      return true
    end
    board.spots[origin], board.spots[move] = undo[0], undo[1]
    false
  end

  def increment_move(spot, move_step)
    [spot[0] + move_step[0], spot[1] + move_step[1]]
  end

  def horizontal_distance(spot_a, spot_b)
    (spot_a[0] - spot_b[0]).abs
  end
end

class Pawn < ChessPiece
  attr_accessor :en_passable
  attr_writer   :move_steps

  def initialize(color)
    @color = color
    @en_passable = false
    @icon = (@color == 'B' ? "\u265F" : "\u2659")
    @letter = ''
    @move_steps = (@color == 'W' ? [[0, 1, 2],[-1, 1, 1], [1, 1, 1]] :
                              [[0, -1, 2], [-1, -1, 1], [1, -1, 1]])
    @value = 1
  end

  def generate_moves(board, pawn_spot, check_for_check = true)
    spots = board.spots
    moves = super
    moves.delete_if do |move|
      x_distance = horizontal_distance(pawn_spot, move)
      if x_distance == 0 && spots[move] != 0
        true
      elsif x_distance != 0 && spots[move] == 0 &&
            !can_take_en_passant?(spots, pawn_spot, move)
        true
      else
        false
      end
    end
    moves
  end

  def can_take_en_passant?(spots, pawn_spot, move)
    if @color == 'W'
      target_pawn = spots[[move[0], move[1] - 1]]
    else
      target_pawn = spots[[move[0], move[1] + 1]]
    end
    return false if !(target_pawn.is_a?(Pawn) &&
                      target_pawn.color != @color &&
                      target_pawn.en_passable)
    true
  end
end

class Rook < ChessPiece
  attr_accessor :has_moved

  def initialize(color)
    @color = color
    @has_moved = false
    @icon = (@color == 'B' ? "\u265C" : "\u2656")
    @letter = 'R'
    @move_steps = [[0, 1, 7], [0, -1, 7], [-1, 0, 7], [1, 0, 7]]
    @value = 5
  end
end

class Knight < ChessPiece

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265E" : "\u2658")
    @letter = 'N'
    @move_steps = [[1, 2, 1], [1, -2, 1], [-1, 2, 1], [-1, -2, 1], [2, 1, 1], [2, -1, 1], [-2, 1, 1], [-2, -1, 1]]
    @value = 3
  end
end

class Bishop < ChessPiece

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265D" : "\u2657")
    @letter = 'B'
    @move_steps = [[1, 1, 7], [1, -1, 7], [-1, 1, 7], [-1, -1, 7]]
    @value = 3
  end
end

class King < ChessPiece
  attr_writer :move_steps

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @letter = 'K'
    @move_steps = [[0, 1, 1], [1, 1, 1], [1, 0, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 0, 1], [-1, 1, 1], [-2, 0, 1], [2, 0, 1]]
    @value = 10000
  end

  def generate_moves(board, king_spot, check_for_check = true)
    moves = super
    # check_for_check is needed to prevent an infinite loop when calling
    # spot_in_check verifies the opposing king's threatened spots
    if check_for_check
      moves.delete_if do |move|
        x_move = horizontal_distance(king_spot, move)
        if board.spot_in_check?(@color, move)
          true
        elsif x_move > 1 && !can_castle?(board, king_spot, move, x_move)
          true
        else
          false
        end
      end
    end
    moves
  end

  def can_castle?(board, king_spot, move, x_move)
    spots = board.spots
    return false if !(move[0] == 3 || move[0] == 7)
    rook_spot = move.dup
    rook_spot[0] = (move[0] == 3 ? 1 : 8)
    rook = spots[rook_spot]
    if !rook.is_a?(Rook)
      return false
    elsif rook.has_moved
      return false
    end

    x = (move[0] == 3 ? -1 : 1)
    x_move.times do |i|
      spot = spots[[king_spot[0] + (x*(i + 1)), king_spot[1]]]
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
    @move_steps = [[0, 1, 7], [1, 1, 7], [1, 0, 7], [1, -1, 7], [0, -1, 7], [-1, -1, 7], [-1, 0, 7], [-1, 1, 7]]
    @value = 10
  end
end
