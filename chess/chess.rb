require './board.rb'
require './player.rb'
require './record.rb'

@@letter_index = [*('a'..'h')]

class Chess
  def initialize
    @board = Board.new
    @board.place_pieces
    @white = Human.new('W')
    @black = Human.new('B')
    @logger = Logger.new
    @next = false
  end

  def play(player, restore = false)
    @board.render
    round = 1
    player_color = player.color
    while !(checkmate(round, player) || draw(player) || @next)
      loop do
        origin, destination = *fetch_move_input(round, player, restore)
        if !origin.is_a? Array
          non_chess_move(player, origin)
          @next = true
          break
        elsif @board.validate_move(player_color, origin, destination)
          check_for_promotion(player, origin, destination) if !restore
          check_for_check(round, player, origin, destination)
          @board.update(round, player, origin, destination, @logger)
          @board.render
          round += 1 if player.color == "B"
          player, player_color = *swap_players(player)
          break
        else
          puts 'invalid move'
          exit
        end
      end
    end
    #@board.render
    #menu
  end

  def swap_players(player)
    player == @white ? (player = @black) : (player = @white)
    player_color = player.color
    [player, player_color]
  end

  def check_for_check(round, player, origin, destination)
    player, color = *swap_players(player)
    @board.update(round, player, origin, destination)
    if @board.spot_in_check?(color, @board.find_king(color))
      puts 'Check!'
      @logger.tokens[:check] = "+"
    end
    @board.process_undos
  end

  def non_chess_move(player, input)
    draw(player, true) if input == "draw"
    win(swap_players(player)[0], true) if input == "win"
  end

  def fetch_move_input(round, player, restore)
    return parse_player_input(player.take_turn) if !restore
    color = player.color
    player = (player == @white ? 0 : 1)
    print restore[round - 1][player]
    parse_SAN(restore[round - 1][player], color)
  end

  def parse_player_input(input)         #converts ex:'a2a4' to [[1, 2], [1, 4]]
    output = [input[0..1].split(''), input[2..3].split('')]
    output.each do |x|
      x[0] = @@letter_index.index(x[0]) + 1
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
      origin, destination = "draw", ""
    elsif move == "1-0" || move == "0-1"
      origin, destination = "win", ""
    else
      if /=/ === move
        @board.promotion = [move.scan(/=([BNRKQ])/).flatten.first, color]
        move = move.scan(/\A(\S+)=\S+\z/).flatten.first
        print move
      end
      move_parts = move.scan(/([BNRKQ]?)([a-h]?\d?)x?([a-h]\d)\S?/).flatten
      piece = move_parts[0]
      origin_SAN = move_parts[1]
      destination_SAN = move_parts[2]

      destination = [@@letter_index.index(destination_SAN[0]) + 1, destination_SAN[1].to_i]
      if !(origin_SAN =~ /\A[a-h][1-8]\z/)
        origin = @board.find_SAN_piece(piece, color, origin_SAN, destination)
      else
        origin = origin_SAN
      end
    end
    [origin, destination]
  end

    def check_for_promotion(player, origin, destination)
    if @board.need_promote?(origin, destination)
      @board.promotion = [player.pawn_promote, player.color]
      @logger.tokens[:promotion] = @board.promotion[0]
    end
  end

  def checkmate(round, player)
    king_spot = @board.find_king(player.color)
    king = @board.spots[king_spot]
    if @board.spot_in_check?(player.color, king_spot)
      if king.generate_moves(@board, king_spot).size != 0
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
        moves = @board.spots[spot].generate_moves(@board, spot, false)
        moves.each do |move|
          @board.update(round, player, spot, move)
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
  end

  def draw(player, input = false)
    color = player.color
    spots = @board.spots
    if stalemate(spots, color) || dead_position || input
      puts "It's a draw."
      @logger.tokens[:end_game] = "1/2-1/2"
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
           current_piece.generate_moves(@board, spot, false).size != 0
          return false
        end
      end
      puts 'Stalemate!'
      return true
    end
  end

  def dead_position
    false
  end

  def threefold_repetition
    false
  end

  def fifty_move_rule
    false
  end

  def menu
    puts "(n)ew game, (l)oad game, or (q)uit?"
    loop do
      input = gets.chomp
      case input
      when "new game", "new", "n" then new_game
      when "load game", "load", "l" then load_game
      when "quit", "q" then exit
      end
    end
    play(@white)
  end

  def new_game
    @white.name_player
    @black.name_player
    @logger.write_default_tags
    @logger.write_names(@white.name, @black.name)
    play(@white)
  end

  def load_game(filename = "test.pgn")
    file_loader = Serialize.new
    restore = file_loader.restore(filename, @logger)
    play(@white, restore)
  end
end

#chess = Chess.new
#chess.new_game
#chess.load_game
#chess.menu

filename = "Adams.pgn"
File.foreach(filename, "\r\n\r\n[").with_index do |game, i|
  chess = Chess.new
  #p game
  File.open('test.pgn', 'w+') do |current_game|
    current_game.write("[") if i != 0
    current_game.write(game)
  end
  chess.load_game
  sleep(1)
end
