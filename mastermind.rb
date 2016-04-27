class Mastermind

  def initialize
    @player = Player.new
  end

  def play
    intro

    until @turn == 12 || @board.solved?
      guess = @player.guess
      @board.update_guess_history(guess, @turn)
      @board.update_feedback_history(@turn)
      @board.display

      puts "\nPlease type 4 of RGBOPW for your guess:"

      @turn += 1
    end

    @turn == 12 ? lose : win
  end

  private

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

  def intro
    @board = Board.new
    @turn = 0

    puts "Welcome to Mastermind!\n\n"
    @board.display
    puts "\nYour goal is to guess the secret code consisting of 4 ordered colors within 12 turns."
    puts "Each guess will receive one + each time both color and spot are guessed correctly, and one - per correctly guessed color in the wrong spot."
    puts "\nType your guess as 4 capital letters in a row. The options are:"
    puts "(B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (W)hite\n\n"
  end

  class Board

    def initialize
      @colors = ["B", "G", "O", "P", "R", "W"]
      @code = Array.new(4) { @colors[rand(6)] }
      @guess_history = Array.new(12) { [" ", " ", " ", " "] }
      @feedback_history = Array.new(12) { [" ", " ", " ", " "] }
    end

    def display
      12.times do |i|
        print "\n ------------------\n"
        print "| "
        4.times { |j| print "#{@guess_history[i][j]} " }
        print "|"
        4.times { |j| print "#{@feedback_history[i][j]} " }
        print "|"
      end
      print "\n ------------------\n"
    end

    def update_feedback_history(turn)
      @feedback_history[turn] = []
      code = @code.dup

      4.times do |i|
        if @guess_history[turn][i] == code[i]
          @feedback_history[turn] << "+"
          code[i] = 0                           #so it will be ignored by include
        end
      end

      4.times do |i|
        @feedback_history[turn] << "-" if code.include?(@guess_history[turn][i])
      end

      (4 - @feedback_history[turn].length).times { @feedback_history[turn] << " " }
    end

    def update_guess_history(guess, turn)
      @guess_history[turn] = guess.split("").to_a
    end

    def solved?
      @guess_history.include?(@code)
    end

  end

  class Player

    def guess
      loop do
        input = gets.chomp
        case input
          when /^[B, G, O, P, R, W]{4}$/ then return input
        end
      end
    end

    class AI < Player
    end

    class Human < Player
    end
      
  end

end

game = Mastermind.new
game.play
