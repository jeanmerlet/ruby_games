class Mastermind

  def initialize
    @board = Board.new
    @player = Player.new
    @turn = 0
  end

  def play
    until @turn = 12 || @board.solved?
      @board.display
      @player.guess
      @turn += 1
    end
    @turn == 12 ? lose || win
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
        when "y", "yes" then start
        when "n", "no" then exit
      end
    end
  end

  class Board

    def initialize
      @code = Array.new(4) { rand(6) }
    end

    def display
    end

    def feedback
    end

    def solved?
    end

  end

  class Player

    def guess
      loop do
        input = gets.chomp
        case input
          when (0..5) then return input
        end
      end
    end
      
  end

end
