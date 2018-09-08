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
    until checkmate(player.color, @board.spots) || draw(player.color)
      @board.render
      check_for_check(player.color)

      player_move = parse_player_input(player.take_turn)
      origin, destination = player_move[0], player_move[1]
      piece = @board.spots[origin]

      if @board.validate_move(player.color, @board.spots, origin, destination)
        record_move(player.color, origin, destination, @markers)
        @board.update(origin, destination)
        player == @white ? (player = @black) : (player = @white)
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
    if @board.check?(player_color, @board.spots, king_spot)
      puts 'Check!'
      @markers[0] = '+'
    else
      @markers[0] = ''
    end
  end

  def checkmate(player_color, board)
    king_spot = @board.find_king(player_color)
    if @board.check?(player_color, board, king_spot)
      @board.generate_moves(player_color, king_spot).each do |move|
        return false unless @board.check?(player_color, move)
      end
      winning_color = (player_color == 'W' ? 'Black' : 'White')
      print 'Checkmate'
      print "\n#{winning_color} wins!"
      return true
    end
    false
  end

  def draw(player)
    false
  end

  def record_move(color, origin, destination, special_markers)
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
      file.write("#{piece}#{capture_indicator}#{move}#{special_markers[0]} ")
    end
  end
end

chess = Chess.new
chess.new_game
