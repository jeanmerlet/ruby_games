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
    play
  end

  def play
    player = @white
    until checkmate(player) || draw(player)
      @board.render
      parsed_input = parse_player_input(player.take_turn)
      origin, destination = parsed_input[0], parsed_input[1]
      if @board.validate(player, origin, destination)
        @board.update(origin, destination)
        player == @white ? (player = @black) : (player = @white)
      else
        puts 'INVALID MOVE LOL'
      end
    end
    #end game methods
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
    false
  end

  def draw(player)
    false
  end
end

chess = Chess.new
chess.new_game
