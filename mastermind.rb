class Mastermind

  def initialize
    choose_game_type
    code = @codemaster.create_code
    @board = Board.new(code)
    @turn = 0
    play
  end

  private

  def play
    until @turn == 12 || @board.solved?
      guess = @codebreaker.guess
      @board.update_guess_history(guess, @turn)
      @board.update_feedback_history(@turn)
      @board.render

      puts "\nPlease type 4 of RGBOPW for your guess:"

      @turn += 1
    end

    @board.solved? ? win : lose
  end

  def win
    puts "You guessed the code - you win! :>"
  end

  def lose
    puts "You're out of turns - you lose! :<"
  end

  def choose_game_type
    puts "Welcome to Mastermind!"
    puts "Would you like to be code(m)aster or code(b)reaker?"

    loop do
      input = gets.chomp
      case input
        when "m", "codemaster"
          codemaster_start
          break
        when "b", "codebreaker"
          codebreaker_start
          break
      end
    end
  end

  def codemaster_start
    @codemaster = Player::Human.new
    @codebreaker = Player::AI.new

    puts "\nCome up with a code and watch the AI attempt to guess it."
    puts "\nType your code as 4 capital letters in a row (ex: BBBB). The options are:"
    puts "(B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (W)hite\n\n"
  end

  def codebreaker_start
    @codemaster = Player::AI.new
    @codebreaker = Player::Human.new

    puts "\nYour goal is to guess the secret code consisting of 4 ordered colors within 12 turns."
    puts "Each guess will receive feedback: one + each time both color and spot are guessed correctly, and one - per correctly guessed color in the wrong spot."
    puts "\nType your guess as 4 capital letters in a row (ex: BBBB). The options are:"
    puts "(B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (W)hite\n\n"
  end

  class Board

    def initialize(code)
      @code = code
      @guess_history = Array.new(12) { [" ", " ", " ", " "] }
      @feedback_history = Array.new(12) { [" ", " ", " ", " "] }
    end

    def render
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
          code[i] = 0
        end
      end

      4.times do |i|
        if code.include?(@guess_history[turn][i])
          @feedback_history[turn] << "-" 
          code[code.index(@guess_history[turn][i])] = 0
        end
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

    class Human < Player

      def create_code
        four_color_input
      end

      def guess
        four_color_input
      end

      def four_color_input
        loop do
          input = gets.chomp
          case input
            when /^[B, G, O, P, R, W]{4}$/ then return input
          end
        end
      end
    end

    class AI < Player

      def create_code
        colors = ["B", "G", "O", "P", "R", "W"]
        Array.new(4) { colors[rand(6)] }
      end

      def guess
      end

    end
      
  end

end

game = Mastermind.new
