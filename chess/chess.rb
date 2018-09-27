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
    @turn = 1
    @markers = ['', 'x', '=', '0 - 0']
    File.open('game.pgn', 'w+') {|f| }
    play
  end

  def load_game
  end

  def play
    player = @white
    player_color = @white.color
    until checkmate?(player_color) || draw?(player_color)
      @board.render
      check_for_check(player_color)

      player_move = parse_player_input(player.take_turn)
      origin, destination = player_move[0], player_move[1]

      if @board.validate_move(player_color, origin, destination)
        if @board.can_promote?(origin, destination)
          promotion = [player.pawn_promote, player_color]
        end
        record_move(player_color, origin, destination)
        @board.update(origin, destination, promotion)
        player == @white ? (player = @black) : (player = @white)
        player_color = player.color
      else
        puts 'INVALID MOVE LOL'
      end
    end
    @board.render
  end

  def parse_player_input(input)         #converts ex:'a2a4' to [[1, 2], [1, 4]]
    output = [input[0..1].split(''), input[2..3].split('')]
    output.each do |x|
      x[0] = @letter_index.index(x[0]) + 1
      x[1] = x[1].to_i
    end
    output
  end

  def check_for_check(player_color)
    king_spot = @board.find_king(player_color)
    if @board.spot_in_check?(player_color, king_spot)
      puts 'Check!'
      @markers[0] = '+'
    else
      @markers[0] = ''
    end
  end

  def checkmate?(player_color)
    king_spot = @board.find_king(player_color)
    king = @board.spots[king_spot]
    if @board.spot_in_check?(player_color, king_spot)
      if king.generate_moves(@board, king_spot, true).size != 0
        return false 
      elsif true #player can't move a different piece to end check
        return false
      else
        winning_color = (player_color == 'W' ? 'Black' : 'White')
        print 'Checkmate'
        print "\n#{winning_color} wins!"
        return true
      end
    end
    false
  end

  def draw?(player)
    false
  end

  def record_move(color, origin, destination)
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
