require './board.rb'
require './player.rb'
require './record.rb'

class Chess

  def initialize
    @letter_index = [*('a'..'h')]
  end

  def new_game
    @board = Board.new
    @board.place_pieces
    @white = Human.new('W')
    @black = Human.new('B')
    @logger = Logger.new
    play
    #menu
  end

  def menu
    load_game(gets.chomp)
  end

  def play
    player = @white
    until checkmate(player) || draw?(player)
      @board.render

      if @board.spot_in_check?(player.color, @board.find_king(player.color))
        check_message
        @logger.uncommon[:check] = true
      else
        @logger.uncommon[:check] = false
      end
      player_move = parse_player_input(player.take_turn)
      origin, destination = player_move[0], player_move[1]

      if @board.validate_move(player.color, origin, destination)
        if @board.need_promote?(origin, destination)
          @board.promotion = [player.pawn_promote, player.color]
          @logger.uncommon[promotion] = @board.promotion[0]
        end
        @logger.record_move(@board, player, origin, destination)
        @board.update(origin, destination, @logger)
        player == @white ? (player = @black) : (player = @white)
      else
        puts 'INVALID MOVE LOL'
      end
    end
    @board.render
    #new_game
  end

  def parse_player_input(input)         #converts ex:'a2a4' to [[1, 2], [1, 4]]
    output = [input[0..1].split(''), input[2..3].split('')]
    output.each do |x|
      x[0] = @letter_index.index(x[0]) + 1
      x[1] = x[1].to_i
    end
    output
  end

  def checkmate(player)
    king_spot = @board.find_king(player.color)
    king = @board.spots[king_spot]
    if @board.spot_in_check?(player.color, king_spot)
      if king.generate_moves(@board, king_spot, true).size != 0
        return false 
      elsif !non_king_move_can_prevent_check?(player, king_spot)
        #puts "Checkmate #{player.name}!"
        @logger.uncommon[checkmate] = true
        win(player)
        return true
      end
    end
    false
  end

  def non_king_move_can_prevent_check?(player, king_spot)
    clone_board = @board.dup
    clone_board.spots = @board.spots.dup
    
    @board.spots.each do |spot, piece|
      piece = @board.spots[spot]
      if piece != 0 && piece.color == player.color
        moves = @board.spots[spot].generate_moves(@board, spot)
        moves.each do |move|
          clone_board.update(spot, move)
          return true if !clone_board.spot_in_check?(player.color, king_spot)
          clone_board.spots = @board.spots.dup
        end
      end
    end
    false
  end

  def draw?(player)
    color = player.color
    spots = @board.spots
    if stalemate(spots, color) || threefold_repetition || fifty_move_rule
      return true
    end
    false
  end

  def stalemate(spots, color)
    if !@board.spot_in_check?(color, @board.find_king(color))
      spots.each do |spot, piece|
        current_piece = spots[spot]
        if current_piece != 0 &&
           current_piece.color == color &&
           current_piece.generate_moves(@board, spot).size != 0
          return false
        end
      end
      puts 'Stalemate!'
      return true
    end
  end

  def threefold_repetition
  end

  def fifty_move_rule
  end

  def win(player)
    winning_color = (player.color == 'W' ? 'Black' : 'White')
    puts "#{winning_color} wins."
  end

  def check_message
    puts 'Check!'
  end
end

chess = Chess.new
chess.new_game
