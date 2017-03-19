require './board'
require './player'

class Chess

  def initialize
  end

  def start
    puts "(N)ew game or (L)oad?"
    loop do
      case gets.chomp
        when "N"
          new_game
          break
        when "L"
          puts "Enter filename:\n"
          savegame = gets.chomp
          load_game(savegame)
          break
        else
          puts "Type N or L"
      end
    end
  end

  def play
  end

  def new_game
    create_chess_set
    create_players
    play
  end

  def create_chess_set
    @board = Board.new
    @board.populate_spots
  end

  def create_players
    @player1 = Player.new(white)
    @player2 = Player.new(black)
  end

  def save_game
  end

  def load_game(filename)
    puts filename
    play
  end

end

game = Chess.new
game.start
