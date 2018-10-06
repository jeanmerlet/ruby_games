require './board.rb'
require './player.rb'

class Chess

  def initialize
    @letter_index = [*('a'..'h')]
  end

  def new_game
    @board = Board.new
    @board.place_pieces
    @white = Human.new('W')
    @black = Human.new('B')
    @log = Log.new
    play
  end

  def save_game
  end

  def load_game
  end

  def play
    player = @white
    until checkmate?(player) || draw?(player)
      @board.render

      if @board.spot_in_check?(player.color, @board.find_king(player.color))
        check_message
      end
      player_move = parse_player_input(player.take_turn)
      origin, destination = player_move[0], player_move[1]

      if @board.validate_move(player.color, origin, destination)
        if @board.can_promote?(origin, destination)
          promotion = [player.pawn_promote, player.color]
        end
        #@log.record_move(player, origin, destination)
        @board.update(origin, destination, promotion)
        player == @white ? (player = @black) : (player = @white)
      else
        puts 'INVALID MOVE LOL'
      end
    end
    @board.render
    win(player)
  end

  def parse_player_input(input)         #converts ex:'a2a4' to [[1, 2], [1, 4]]
    output = [input[0..1].split(''), input[2..3].split('')]
    output.each do |x|
      x[0] = @letter_index.index(x[0]) + 1
      x[1] = x[1].to_i
    end
    output
  end

  def check_message
    puts 'Check!'
  end

  def checkmate?(player)
    king_spot = @board.find_king(player.color)
    king = @board.spots[king_spot]
    if @board.spot_in_check?(player.color, king_spot)
      if king.generate_moves(@board, king_spot, true).size != 0
        return false 
      elsif !non_king_piece_can_prevent_check?(player, king_spot)
        return true
      end
    end
    false
  end

  def non_king_piece_can_prevent_check?(player, king_spot)
    clone_board = @board.dup
    clone_board.spots = @board.spots.dup
    
    @board.spots.each do |spot, piece|
      current_spot = @board.spots[spot]
      if current_spot != 0 && current_spot.color == player.color
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

  def win(player)
    winning_color = (player.color == 'W' ? 'Black' : 'White')
    puts "\nCheckmate!"
    puts "#{winning_color} wins."
  end

  def draw?(player)
    false
  end
end

class Log
  attr_accessor :savefile, :markers

  def initialize
    @savefile = File.open('game.pgn', 'w+') {|f|}
    @turn = 1
    @last_move = 0
    @undo = 0
    @markers = ['', 'x', '=', '0 - 0']
  end

  def undo(player, move)
  end

  def redo(player, move)
  end

  def record_move(player, move)
    piece = @board.spots[origin].letter
    if @board.spots[destination] != 0
      capture_indicator = 'x'
    else
      capture_indicator = ''
    end

    #converts ex: [1, 4] to 'a4'
    move = @letter_index[destination[0]-1] + destination[1].to_s

    File.open('game.pgn', 'a') do |file|
      if color == 'W'
        file.write("#{@turn}. ")
      else
        @turn += 1
      end
      file.write("#{piece}#{capture_indicator}#{move}#{@markers[0]} ")
    end
  end
end

chess = Chess.new
chess.new_game
