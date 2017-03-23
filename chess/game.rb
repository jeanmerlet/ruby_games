require './board'
require './player'

class Chess

  def initialize
    @checkmate = false
    @tie = false
    @save = false
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
    until @checkmate || @tie
      @board.render
      loop do
        input = @current_player.input
        if validate(input)
          @board.update(input)
          break
        elsif input == 'save'
          save_game(@current_player, @white, @black, @board.move_history)
        end
      end
      next if game_over?
      switch_players
    end
    @checkmate ? win(@current_player) : tie
  end

  def validate(move)
  end

  def game_over?
  end

  def win(player)
    puts "#{player.name} wins!"
    quit
  end

  def tie
    puts "Tie game."
    quit
  end

  def new_game
    create_chess_set
    create_players
    play
  end

  def create_chess_set
    @board = Board.new
    @board.populate
  end

  def create_players
    @white = Player.new(white)
    @black = Player.new(black)
    @current_player = @white
  end

  def switch_players
    @current_player = (@current_player == @white ? @black : @white)
  end

  def save_game(current_player, white, black, move_history)
    #save stuff
    exit
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
game.create_chess_set
