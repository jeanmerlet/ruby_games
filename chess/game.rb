require './board'
require './player'

class Chess

  def initialize
    @letters = ('a'..'h').to_a
    @numbers = ('1'..'8').to_a
  end

  def start
    puts "(N)ew game or (L)oad?"
    loop do
      case gets.chomp
        when "N"
          new_game
          break
        when "L"
          puts "Enter filename:"
          savegame = gets.chomp
          load_game(savegame)
          break
        else
          puts "Type N or L"
      end
    end
  end

  def play
    until game_over?
      @board.render
      loop do
        input = @current_player.input
        if input == 'save'
          save_game(@current_player, @white, @black, @board.move_history)
        elsif validate_move(input)
          @board.update(input)
          break
        end
      end
      switch_players unless game_over?
      print "\n    Check!" if @board.check
    end
    @board.checkmate ? win(@current_player) : tie
  end

  def validate_move(move)
    piece_to_be_moved = @board.spots[move[0..1]]
    return false if piece_to_be_moved == 'none'
    return false if piece_to_be_moved.color != @current_player.color
    return false if @board.spots[move[2..3]].is_a?(King)
    x = @letters.index(move[2]) - @letters.index(move[0])
    y = @numbers.index(move[3]) - @numbers.index(move[1])
    #check for check
    piece_to_be_moved.allowed_moves.include?([x, y])
  end

  def game_over?
    @board.checkmate || @board.tie
  end

  def win(player)
    puts "#{player.name} wins!"
    quit
  end

  def tie
    puts "Tie game."
    quit
  end

  def create_chess_set
    @board = Board.new
    @board.populate
  end

  def create_players
    @white = Player::Human.new('white')
    @black = Player::Human.new('black')
    @current_player = @white
  end

  def switch_players
    @current_player = (@current_player == @white ? @black : @white)
  end

  def new_game
    create_chess_set
    create_players
    play
  end

  def save_game(current_player, white, black, move_history)
    #save stuff
    quit
  end

  def load_game(filename)
    puts filename
    play
  end

  def quit
    exit
  end

end

game = Chess.new
game.start
