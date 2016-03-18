class Mastermind

  def initialize
    @player = Player.new
  end

  def play
    @board = Board.new
    @turn = 0

    @board.display
    puts "\nIntro"

    until @turn == 12 || @board.solved?
      guess = @player.guess
      @board.update_guess_history(guess, @turn)
      @board.display
      @turn += 1
    end

    @turn == 12 ? lose : win
  end

  def lose
    puts "You're out of turns - you lose! :<"
    play_again
  end

  def win
    puts "You guessed the code - you win! :>"
    play_again
  end

  def play_again
    puts "Play again? (y)es or (n)o"
    loop do
      input = gets.chomp
      case input
        when "y", "yes" then play
        when "n", "no" then exit
      end
    end
  end

  class Board

    def initialize
      @colors = ["B", "G", "O", "P", "R", "W"]
      @code = Array.new(4) { @colors[rand(6)] }
      @guess_history = Array.new(12) { [" ", " ", " ", " "] }
    end

    def display
      12.times do |i|
        print "\n ---------\n"
        print "| "
        4.times { |j| print "#{@guess_history[i][j]} " }
        print "|"
      end
      print "\n ---------\n"
    end

    def update_guess_history(guess, turn)
      @guess_history[turn] = guess.split("").to_a
    end

    def solved?
      puts "in solved"
      @guess_history.last == @code
    end

  end

  class Player

    def guess
      puts "in guess"
      loop do
        input = gets.chomp
        case input
          when /^[B, G, O, P, R, W]{4}$/ then return input
        end
      end
    end
      
  end

end

game = Mastermind.new
game.play
