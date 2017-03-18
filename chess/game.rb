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

  def new_game
    @board = Board.new
    @player1 = Player.new(white)
    @player2 = Player.new(black)
    play
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
