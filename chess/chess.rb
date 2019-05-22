require './board.rb'
require './player.rb'
require './record.rb'

$letter_index = [*('a'..'h')]
$stdin.set_encoding("utf-8")
$game_number = 1

class Chess
  def initialize
    @board = Board.new
    @board.place_pieces
    @logger = Logger.new
    @restore = false
  end

  def play(player, color, opponent, test_next = false, round = 1)
    @board.render
    while !(checkmate(round, player) || draw(player) || test_next)
      loop do
        origin, destination = *fetch_move_input(round, player, @board)
        if !origin.is_a? Array
          non_chess_move(player, origin)
          test_next = true if @restore
          break
        elsif @board.validate_move(color, origin, destination)
          check_for_promotion(player, origin, destination)
          check_for_check(player, origin, destination)
          @board.update(origin, destination, round, player, opponent, @logger)
          @board.render
          round += 1 if color == "B"
          player, color, opponent = *swap_players(player), player
          @board.king_spot = @board.find_king(color)
          break
        else
          puts "\nInvalid move."
        end
      end
    end
    $game_number += 1
    menu
  end

  def swap_players(player)
    player == @white ? (player = @black) : (player = @white)
    player_color = player.color
    [player, player_color]
  end

  def check_for_check(player, origin, destination)
    player, color = *swap_players(player)
    @board.update(origin, destination)
    if @board.spot_in_check?(color, @board.find_king(color))
      puts 'Check!'
      @logger.tokens[:check] = "+"
    end
    @board.process_undos
  end

  def non_chess_move(player, input)
    if input == "draw"
      opponent = swap_players(player)[0]
      draw(player, "draw", opponent) 
    elsif input == "quit"
      @logger.save
      exit
    elsif input == "san_draw"
      draw(player, true, opponent)
    elsif input == "win"
      win(swap_players(player)[0], true)
    end
  end

  def fetch_move_input(round, player, board)
    return parse_player_input(player, player.take_turn(board)) if !@restore
    color = player.color
    player_index = (player == @white ? 0 : 1)
    move = parse_SAN(@restore[round - 1][player_index], color)
    if move == "*"
      @restore = false
      return parse_player_input(player, player.take_turn(board))
    end
    move
  end

  def parse_player_input(player, input)
    return input if player.is_a?(AI)
    return [input, 0] if !(/\A[a-h][1-8][a-h][1-8]\z/ === input)
    output = [input[0..1].split(''), input[2..3].split('')]
    output.each do |x|
      x[0] = $letter_index.index(x[0]) + 1
      x[1] = x[1].to_i
    end
    output
  end

  def parse_SAN(move, color)
    if /O-O[+#]?/ === move
      origin = @board.find_king(color)
      if /\AO-O[+#]?\z/ === move 
        destination = (color == 'W' ? [7, 1] : [7, 8])
      else
        destination = (color == 'W' ? [3, 1] : [3, 8])
      end
    elsif move == "1/2-1/2"
      origin, destination = "san_draw", ""
    elsif move == "1-0" || move == "0-1"
      origin, destination = "win", ""
    elsif move == "*"
      return move
    else
      if /=/ === move
        @board.promotion = [move.scan(/=([BNRKQ])/).flatten.first, color]
        move = move.scan(/\A(\S+)=\S+\z/).flatten.first
      end
      move_parts = move.scan(/([BNRKQ]?)([a-h]?\d?)x?([a-h]\d)\S?/).flatten
      piece = move_parts[0]
      origin_SAN = move_parts[1]
      destination_SAN = move_parts[2]

      destination = [$letter_index.index(destination_SAN[0]) + 1, destination_SAN[1].to_i]
      if !(origin_SAN =~ /\A[a-h][1-8]\z/)
        origin = @board.find_SAN_piece(piece, color, origin_SAN, destination)
      else
        origin = origin_SAN
      end
    end
    [origin, destination]
  end

    def check_for_promotion(player, origin, destination)
    if @board.need_promote?(origin, destination) && !@restore
      @board.promotion = [player.pawn_promote, player.color]
    end
  end

  def checkmate(round, player)
    king_spot = @board.king_spot
    king = @board.spots[king_spot]
    if @board.spot_in_check?(player.color, king_spot)
      if king.generate_moves(@board, king_spot, true).size != 0
        return false 
      elsif !non_king_move_can_prevent_check?(round, player, king_spot)
        puts "Checkmate #{player.name}!"
        win(swap_players(player)[0])
        return true
      end
    end
    false
  end

  def non_king_move_can_prevent_check?(round, player, king_spot)
    @board.spots.each do |spot, piece|
      piece = @board.spots[spot]
      if piece != 0 && piece.color == player.color && !piece.is_a?(King)
        moves = @board.spots[spot].generate_moves(@board, spot)
        moves.each do |move|
          @board.update(spot, move)
          if !@board.spot_in_check?(player.color, king_spot)
            @board.process_undos
            return true
          else
            @board.process_undos
          end
        end
      end
    end
    false
  end

  def win(player, input = false)
    print "#{player.name} wins"
    puts (input ? " by forfeit." : ".")
    @logger.tokens[:end_game] = (player.color == 'W' ? "1-0" : "0-1")
    @logger.save(true)
  end

  def draw(player, input = false, opponent = nil)
    color = player.color
    spots = @board.spots
    if stalemate(spots, color) || dead_position(player, spots) || input
      answer = propose_draw(opponent) if input == "draw"
      return false if !answer && input == "draw"
      puts "It's a draw."
      @logger.tokens[:end_game] = "1/2-1/2"
      @logger.save(true)
      return true
    end
    false
  end

  def propose_draw(opponent)
    if opponent.accept_draw?
      puts "#{opponent.name} accepts draw offer."
      return true
    else
      puts "#{opponent.name} rejects draw offer."
      return false
    end
  end

  def stalemate(spots, color)
    spots.each do |spot, piece|
      current_piece = spots[spot]
      if current_piece != 0 &&
         current_piece.color == color &&
         current_piece.generate_moves(@board, spot, true).size != 0
        return false
      end
    end
    puts 'Stalemate!'
    return true
  end

  def dead_position(player, spots)
    opponent = swap_players(player)[0]
    return false if player.pieces > 2 || opponent.pieces > 2
    player_a, player_b = [], []
    piece_a, piece_b = 0, 0
    if player.pieces == 2 && opponent.pieces == 2
      spots.each do |spot, value|
        piece = spots[spot]
        if piece != 0 && piece.is_a?(Bishop)
          piece_a = piece if piece.color == player.color
          piece_b = piece if piece.color == opponent.color
        end
      end
      if piece_a != 0 && piece_b != 0 && piece_a.parity == piece_b.parity
        puts "King and bishop vs. king and bishop with bishops"
        puts "on the same color - dead position."
        return true
      end
    elsif (player.pieces == 2 && opponent.pieces == 1) ||
          (player.pieces == 1 && opponent.pieces == 2)
      spots.each do |spot, value|
        piece = spots[spot]
        if piece != 0 && (piece.is_a?(Knight) || piece.is_a?(Bishop))
          piece_name = (piece.letter == "N" ? "knight" : "bishop")
          puts "King and #{piece_name} vs. king - dead position"
          return true
        end
      end
    elsif player.pieces == 1 && opponent.pieces == 1
      puts "King vs. king - dead position."
      return true
    end
    false
  end

  def reset
    @board = Board.new
    @board.place_pieces
    @logger = Logger.new
    @restore = false
  end

  def setup_players
    @white = choose_player_type('W')
    @black = choose_player_type('B')
    @white.name_player
    @black.name_player
  end

  def choose_player_type(color)
    pretty_color = (color == 'W' ? 'white' : 'black')
    puts "Is #{pretty_color} a (H)uman or (R)obot player?"
    loop do
      input = gets.chomp
      case input
      when "Human", "human", "H", "h", "" then return Human.new(color)
      when "Robot", "robot", "R", "r" then return AI.new(color)
      else
        puts "The options are (H)uman or (R)obot."
      end
    end
  end

  def menu
    puts "(n)ew game, (l)oad game, or (q)uit?"
    loop do
      input = gets.chomp
      case input
      when "new game", "new", "n", ""
        new_game
        break
      when "load game", "load", "l"
        load_game
        break
      when "quit", "q" then exit
      end
    end
    play(@white, 'W', @black)
  end

  def new_game
    reset if $game_number > 1
    setup_players
    @logger.write_default_tags(@white.name, @black.name)
  end

  def load_game
    puts "Enter filename:"
    filename = ""
    loop do
      filename = gets.chomp
      if File.file?(filename)
        break
      elsif filename == ""
        filename = "game.pgn"
        break
      else
        puts "no such file exists :("
      end
    end
    setup_players
    file_loader = Serialize.new
    @restore = file_loader.restore(filename, @logger, @black, @white)
  end
end

chess = Chess.new
chess.menu
