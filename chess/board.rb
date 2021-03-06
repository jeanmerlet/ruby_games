require 'colorize'

class Board
  attr_accessor :spots, :king_spot, :promotion
  attr_reader   :en_passant

  def initialize
    # hash with [x, y] coordinate arrays as keys and 0 as default values
    @spots = Hash[[*1..8].repeated_permutation(2).map {|x| [x, 0]}]
    @king_spot = [5, 1]
    @en_passant = false
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
        elsif spot[0] == 3
          @spots[spot] = Bishop.new('W', "odd")
        elsif spot[0] == 4
          @spots[spot] = Queen.new('W')
        elsif spot[0] == 5
          @spots[spot] = King.new('W')
        elsif spot[0] == 6
          @spots[spot] = Bishop.new('W', "even")
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
        elsif spot[0] == 3
          @spots[spot] = Bishop.new('B', "even")
        elsif spot[0] == 4
          @spots[spot] = Queen.new('B')
        elsif spot[0] == 5
          @spots[spot] = King.new('B')
        elsif spot[0] == 6
          @spots[spot] = Bishop.new('B', "odd")
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

  def update(origin, destination, round = nil, player = nil, opponent = nil, logger = nil)
    piece = @spots[origin]
    if piece.is_a?(Pawn)
      pawn_update(piece, origin, destination, logger)
    else
      @en_passant = false if logger
      if piece.is_a?(King)
        castle_update(piece, origin, destination, logger)
      elsif piece.is_a?(Rook) && logger
        piece.has_moved = true
      end
    end
    if logger
      logger.record_move(self, round, player, opponent, origin, destination)
    else
      @undo = [[origin.dup, @spots[origin].dup], [destination.dup, @spots[destination].dup]]
    end
    @spots[origin], @spots[destination] = 0, @spots[origin]
  end

  def pawn_update(piece, origin, destination, logger)
    if (destination[1] - origin[1]).abs == 2
      @en_passant = destination.dup if logger
    elsif piece.horizontal_distance(origin, destination) == 1 &&
          @spots[destination] == 0 && @en_passant
      if logger
        logger.tokens[:en_passant] = true
        @spots[@en_passant] = 0
        @en_passant = false
      else
        @en_passant_undo = [true, @en_passant.dup, @spots[@en_passant].dup]
        @spots[@en_passant] = 0
      end
    else
      @en_passant = false if logger
    end
    if @promotion && logger
      @spots[origin] = create_promotion_piece(origin)
      logger.tokens[:promotion] = @promotion[0].dup
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
      elsif destination[0] == 7
        rook_origin[0] = 8
        rook_destination[0] = 6
        logger.tokens[:castle] = "O-O" if logger
      end
      @castle_undo = [true, rook_origin.dup, rook_destination.dup] if !logger
      @spots[rook_origin], @spots[rook_destination] = 0, @spots[rook_origin]
    end
    if logger
      king.move_steps[0][2] = 1
      king.move_steps[1][2] = 1
      king.castle_check = false
    end
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
    if piece == 0 || player_color != piece.color ||
    !piece.generate_moves(self, origin, true).include?(destination)
      return false
    end
    true
  end

  def spot_in_check?(color, target_spot)
    @spots.each do |spot, value|
      piece = @spots[spot]
      if piece != 0 && piece.color != color &&
         piece.generate_moves(self, spot).include?(target_spot)
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
      @spots[spot].generate_moves(self, spot, true).include?(destination)
    end.keys
    if matches.size == 1
      return matches.first
    else
      matches.each do |spot|
        if /\A[a-h]\z/ === origin_SAN
          return spot if ($letter_index.index(origin_SAN) + 1).to_i == spot[0]
        elsif /\A[1-8]\z/ === origin_SAN
          return spot if origin_SAN.to_i == spot[1]
        elsif ($letter_index.index(origin_SAN) + 1).to_i == spot[0] &&
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

  def create_promotion_piece(origin)
    piece_type = @promotion[0]
    color = @promotion[1]
    promotion = case piece_type
    when "Q" then Queen.new(color)
    when "R" then Rook.new(color)
    when "N" then Knight.new(color) 
    when "B"
      if (origin[0]%2 != 0 && color == 'W') || (origin[0]%2 == 0 && color == 'B')
        parity = "even"
      else
        parity = "odd"
      end
      Bishop.new(color, parity) 
    end
    promotion
  end
end

class ChessPiece
  attr_reader :color, :icon, :move_steps, :letter

  # checking is needed to prevent infinite loops when removing self-checking
  # moves calls spot_in_check?, which in turn calls generate_moves

  def generate_moves(board, origin, checking = false)
    king_spot = board.king_spot
    spots = board.spots
    moves = []
    @move_steps.each do |move_step|
      move = increment_move(origin, move_step)
      move_step[2].times do
        break if spots[move] == nil
        break if spots[move] != 0 && spots[move].color == @color
        if checking && moving_self_checks(board, origin, move, king_spot)
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
    board.update(origin, move)
    if board.spot_in_check?(@color, king_spot) && !self.is_a?(King)
      board.process_undos
      return true
    elsif self.is_a?(King) && board.spot_in_check?(@color, move)
      board.process_undos
      return true
    end
    board.process_undos
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

  def generate_moves(board, pawn_spot, checking = false)
    spots = board.spots
    moves = super
    moves.delete_if do |move|
      x_distance = horizontal_distance(pawn_spot, move)
      if x_distance == 0 && spots[move] != 0
        true
      elsif x_distance != 0 && spots[move] == 0
        if !board.en_passant
          true
        else
          !can_take_en_passant?(board, spots, pawn_spot, move)
        end
      else
        false
      end
    end
    moves
  end

  def can_take_en_passant?(board, spots, pawn_spot, move)
    if @color == 'W'
      target_pawn_spot = [move[0], move[1] - 1]
    else
      target_pawn_spot = [move[0], move[1] + 1]
    end
    return false if target_pawn_spot != board.en_passant
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
  attr_accessor :parity

  def initialize(color, parity)
    @color = color
    @icon = (@color == 'B' ? "\u265D" : "\u2657")
    @letter = 'B'
    @move_steps = [[1, 1, 7], [1, -1, 7], [-1, 1, 7], [-1, -1, 7]]
    @value = 3
    @parity = parity
  end
end

class King < ChessPiece
  attr_writer :move_steps, :castle_check

  def initialize(color)
    @color = color
    @icon = (@color == 'B' ? "\u265A" : "\u2654")
    @letter = 'K'
    @move_steps = [[-1, 0, 2], [1, 0, 2], [0, 1, 1], [1, 1, 1], [1, -1, 1], [0, -1, 1], [-1, -1, 1], [-1, 1, 1]]
    @value = 10000
    @castle_check = true
  end

  def generate_moves(board, king_spot, checking = false)
    moves = super
    if @castle_check
      moves.delete_if do |move|
        x_move = horizontal_distance(king_spot, move)
        true if x_move > 1 && !can_castle?(board.spots, king_spot, move)
      end
    end
    moves
  end

  def can_castle?(spots, king_spot, move)
    rook_spot = move.dup
    rook_spot[0] = (move[0] == 3 ? 1 : 8)
    rook = spots[rook_spot]
    if !rook.is_a?(Rook)
      return false
    elsif rook.has_moved
      return false
    end
    return false if rook_spot[0] == 1 && spots[[2, 1]] != 0
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
