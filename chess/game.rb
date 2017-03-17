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
          game = "new"
        when "L"
          puts "Enter filename:\n"
          game = gets.chomp
        else
          puts "Type N or L"
      end
      puts "I got here"
      game == "new" ? new_game : load(game)
      break
    end
  end

  def new_game
    puts "new_game"
  end

  def save
  end

  def load(filename)
    puts "load_game"
  end

end

game = Chess.new
game.start
