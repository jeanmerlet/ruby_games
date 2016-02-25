class TicTacToe

  def initialize
    puts "\nWelcome to Ruby-Powered, Command-Line Tic-Tac-Toe!"
  end

  def start
    new_board
    new_players
    @current_player = @player_two
    play
  end

  private

  def new_board
    puts "\nWhat size board would you like to play on?\nEnter a side length or ENTER to skip:"
    side_length = 3
    loop do
      input = gets.chomp
      case input
        when ("1".."9")
          side_length = input
          break
        when ""
          puts "Using standard 3x3 game board.."
          break
        else
          puts "Please type a number 1-9:"
      end
    end
    @board = Board.new(side_length)
  end

  def new_players
    @player_one = Player.new(name_player(1), "X", @board.side_length)
    @player_two = Player.new(name_player(2), "O", @board.side_length)
  end

  def name_player(number)
    puts "\nEnter a name for player #{number}:"
    name = gets.chomp
  end

  def play
    puts "\nType 1-9 to place, (r)ules for rules or (q)uit to quit."
    until @board.has_win? || @board.is_full? || @current_player.cheats
      @board.display
      switch_player
      puts "It's #{@current_player.name}'s turn - place an #{@current_player.color}."

      chosen_spot = 0
      until (1..@board.side_length**2) === @board.spots[chosen_spot.to_i] || @current_player.cheats
        puts "Spot taken!\n\n" unless chosen_spot == 0
        chosen_spot = @current_player.input
      end

      @board.update(chosen_spot, @current_player.color) unless @current_player.cheats
    end

    @board.display unless @current_player.cheats
    if @board.has_win?
      puts "#{@current_player.name} wins!"
    elsif @board.is_full?
      puts "It's a tie..."
    end
    play_again
  end

  def switch_player
    @current_player = (@current_player == @player_one ? @player_two : @player_one)
  end

  def play_again
    puts "Would you like to play again? (y)es or (n)o"
    loop do
      answer = gets.chomp
      case answer
        when "yes", "y" then start
        when "no", "n" then exit
      end
    end
  end

  class Board

    attr_reader :side_length, :spots

    def initialize(number)
      @side_length = number.to_i
      @spots = (0..@side_length**2).to_a
    end

    def display
      n = @side_length
      spot_fixer = (1..9).to_a << "X" << "O"
      puts ""
      n.times do |j|
        print "----"
        (n-1).times { print "---" }
        puts ""
        n.times { |i| print "|#{" " if spot_fixer.include?(@spots[(i+1)+(j*n)])}#{@spots[(i+1)+(j*n)]}" }
        puts "|"
      end
      print "----"
      (n-1).times { print "---" }
      puts "\n\n"
    end

    def update(number, color)
      @spots[number.to_i] = color
    end

    def has_win?
      n = @side_length
      win_set = Array.new(2) { [] }
      n.times { 2.times { |i| win_set[i] << (i == 0 ? "X" : "O") } }
      test = Array.new(n*2+2) { [] }
      n.times do |j|
        n.times { |i| test[j] << @spots[(i+1)+(j*n)] }      #horizontal
        n.times { |i| test[j+n] << @spots[(i*n+1)+j] }      #vertical
      end
      n.times { |i| test[n*2] << @spots[(i*(n+1)+1)] }      #diagonal
      n.times { |i| test[n*2+1] << @spots[(i*(n-1)+n)] }    #other diagonal

      test.any? { |x| win_set.include?(x) }
    end

    def is_full?
      @spots.none? { |x| (1..@side_length**2) === x }
    end

  end

  class Player

    attr_reader :color, :name, :cheats

    def initialize(name, color, side_length)
      @name = name
      @color = color
      @end_range = side_length**2
      @cheats = false
    end

    def input
      loop do
        player_input = gets.chomp
        case player_input
          when ("1".."#{@end_range}") then return player_input
          when "rules", "r" then see_rules
          when "quit", "q" then quit
          when "cheat"
            cheat
            return
        end
      end
    end

    private

    def see_rules
      puts "The goal of Tic-Tac-Toe is to get three of your 'color' in a row, the traditional Xs and Os in this case. You and your opponent alternate turns, placing one token on any unoccupied spot. The game ends with either a win for one of the players, or in a tie if no spots are left and neither player has won."
      puts "\nAvailable commands:"
      puts "  1-9       places one of your tokens in the corresponding spot"
      puts "  (r)ules   show these rules"
      puts "  (q)uit    quit\n\n"
    end

    def quit
      puts "Really abort this game? (y)es or (n)o"
      loop do
        answer = gets.chomp
        case answer
          when "yes", "y" then exit
          when "no", "n"
            puts "\nAlrighty then...\n\n"
            return
        end
      end
    end

    def cheat
      puts "\nYou cheater!\n#{self.name} 'wins'...\n\n"
      @cheats = true
    end

  end

end

game = TicTacToe.new
game.start
