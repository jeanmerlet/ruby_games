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
    File.open('chess.txt', 'w+') {|f| }
    play
  end

  def play
    player = @white
    until checkmate(player) || draw(player)
      @board.render
      color = player.color
      puts 'check' if @board.check?(color, @board.find_king(color))
      parsed_input = parse_player_input(player.take_turn)
      origin, destination = parsed_input[0], parsed_input[1]
      if @board.validate_move(color, origin, destination)
        record_move(origin, destination)
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

  def checkmate(player)
    king_spot = @board.find_king(player.color)
    if @board.check?(player.color, king_spot)
      @board.generate_moves(player.color, king_spot).each do |move|
        return false unless @board.check?(player.color, move)
      end
      winning_color = (player.color == 'W' ? 'black' : 'white')
      print 'checkmate'
      print "\n#{winning_color} wins!"
      return true
    end
    false
  end

  def draw(player)
    false
  end

  def record_move(origin, destination)
    move_piece = @board.board[origin].letter
    if @board.board[destination] != 0
      capture_piece = @board.board[destination].letter 
    else
      capture_piece = ''
    end
    #converts ex: [1, 4] to 'a4'
    move = @letter_index[destination[0]-1] + destination[1].to_s
    File.open('chess.txt', 'r+') do |file|
      file.write("#{move_piece}#{move}#{capture_piece}")
    end
  end
end

chess = Chess.new
chess.new_game
