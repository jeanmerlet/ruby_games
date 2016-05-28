class Mastermind

  def initialize
    @turn = 0
  end

  def play
    choose_game_type
    code = @codemaster.create_code
    @board = Board.new(code)

    until @board.solved? || @turn == 12
      guess = @codebreaker.guess(@turn, @board.guesses, @board.feedback)
      @board.update_guesses(guess)
      @board.update_feedback
      @board.render

      @turn += 1
    end

    @board.solved? ? win : lose
  end

  private

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
    @codemaster = Player::Codemaster.new
    @codebreaker = AI::Codebreaker.new

    puts "\nCome up with a code and watch the AI attempt to guess it."
    puts "\nType your code as 4 capital letters in a row (ex: BBBB). The options are:"
    puts "(B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (W)hite\n\n"
  end

  def codebreaker_start
    @codemaster = AI::Codemaster.new
    @codebreaker = Player::Codebreaker.new

    puts "\nYour goal is to guess the secret code consisting of 4 ordered colors within 12 turns."
    puts "Each guess will receive feedback: one + each time both color and spot are guessed correctly, and one - per correctly guessed color in the wrong spot."
    puts "\nType your guess as 4 capital letters in a row (ex: BBBB). The options are:"
    puts "(B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (W)hite\n\n"
  end

  def win
    puts "You guessed the code - you win! :>"
  end

  def lose
    puts "You're out of turns - you lose! :<"
  end

  class Board

    attr_reader :guesses, :feedback

    def initialize(code)
      @code = code
      @guesses = []
      @feedback = []
    end

    def render
      swap = @guesses.length
      12.times do |i|
        print "\n -------------\n"
        print i < swap ? "| #{@guesses[i]} | #{@feedback[i]} |" : "|      |      |"
      end
      print "\n -------------\n"
      puts "\nPlease type 4 of BGOPRW for your guess:"
    end

    def update_feedback
      code = @code.dup
      guess = @guesses.last.dup
      @feedback << ""

      4.times do |i|
        if guess[i] == code[i]
          @feedback.last << "+"
          code[i] = "0"
          guess[i] = "1"
        end
      end

      4.times do |i|
        if code.include?(guess[i])
          @feedback.last << "-" 
          code[code.index(guess[i])] = "0"
          guess[i] = "1"
        end
      end

      (4 - @feedback.last.length).times { @feedback.last << " " }
    end

    def update_guesses(guess)
      @guesses << guess
    end

    def solved?
      @guesses.include?(@code)
    end

  end

  class Player

    private

    def four_color_input
      loop do
        input = gets.chomp
        case input
          when /^[B, G, O, P, R, W]{4}$/ then return input
        end
      end
    end

    class Codemaster < Player

      def create_code
        four_color_input
      end

    end

    class Codebreaker < Player

      def guess(a, b, c)
        four_color_input
      end

    end

  end

  class AI

    def initialize
      @colors = ["B", "G", "O", "P", "R", "W"]
    end

    class Codemaster < AI

      def create_code
        code = ""
        4.times { code << @colors[rand(6)] }
        code
      end

    end

    class Codebreaker < AI

      def initialize
        @colors = ["B", "G", "O", "P", "R", "W"]
        @code_set = @colors.repeated_permutation(4).to_a.map { |x| x.join }
        @parsed_feedback = []
      end

      def guess(turn, guesses, feedback)
        return "BBGG" if turn == 0
        @parsed_feedback << count_feedback(turn, feedback)
        eliminate_bad_guesses(turn, guesses)
        @code_set[0]
      end

      private

      def count_feedback(turn, feedback)
        result = [0, 0]
        4.times do |i|
          result[0] += 1 if feedback[turn-1][i] == "+"
          result[1] += 1 if feedback[turn-1][i] == "-"
        end
        result << result[0] + result[1]
      end

      def eliminate_bad_guesses(turn, guesses)
        @code_set -= [guesses.last]

        @code_set.reject! do |code|
          matches = 0
          perfect_matches = 0
          temp_code = code.dup
          result = false

          4.times do |i|
            if temp_code.include?(guesses.last[i])
              matches += 1
              temp_code.sub!(/#{guesses.last[i]}/, "0")
            end
            perfect_matches += 1 if code[i] == guesses.last[i]
          end

          result = true if matches != @parsed_feedback.last[2] || perfect_matches != @parsed_feedback.last[0]
        end
      end

    end
      
  end

end

game = Mastermind.new
game.play
