class TicTacToe

  def initialize
    puts "\nWelcome to Ruby-Powered, Command-Line Tic-Tac-Toe!"
    puts "Type 1-9 to place, (r)ules for rules or (q)uit to quit."
    new_board
    new_players
  end

  def start
    @current_player = @player_two
    play
  end

  private

  def new_board
    @board = (0..9).to_a
    @winning_spots = [[1, 2, 3], [1, 5, 9], [1, 4, 7], [2, 5, 8], [3, 5, 7], [3, 6, 9], [4, 5, 6], [7, 8, 9]]
  end

  def new_players
    @player_one = Player.new(name_player(1), "X")
    @player_two = Player.new(name_player(2), "O")
  end

  def name_player(number)
    puts "\nEnter a name for player #{number}:"
    name = gets.chomp
  end

  def play
    until board_has_win? || board_is_full? || @current_player.cheats
      display_board
      switch_player
      puts "It's #{@current_player.name}'s turn - place an #{@current_player.color}."

      chosen_spot = 0
      until (1..9) === @board[chosen_spot.to_i] || @current_player.cheats
        puts "Spot taken!\n\n" unless chosen_spot == 0
        chosen_spot = @current_player.input
      end

      update_board(chosen_spot, @current_player.color) unless @current_player.cheats
    end

    if board_has_win?
      puts "#{@current_player.name} wins!"
    elsif board_is_full?
      puts "It's a tie..."
    end
    play_again
  end

  def display_board
    puts ""
    3.times do |j|
      puts "-------"
      3.times { |i| print "|#{@board[(i+1)+(j*3)]}" }
      puts "|"
    end
    puts "-------\n\n"
  end

  def switch_player
    @current_player = (@current_player == @player_one ? @player_two : @player_one)
  end

  def play_again
    puts "Would you like to play again? (y)es or (n)o"
    loop do
      answer = gets.chomp
      case answer
        when "yes", "y"
          new_board
          new_players
          start
        when "no", "n" then exit
      end
    end
  end

  def update_board(number, color)
    @board[number.to_i] = color
    @winning_spots.map do |x|
      x.map! { |y| y == (number.to_i) ? y = color : y }
    end
  end

  def board_has_win?
    @winning_spots.any? { |x| [["X", "X", "X"], ["O", "O", "O"]].include?(x) }
  end

  def board_is_full?
    @board.none? { |x| (1..9) === x }
  end

  class Player

    attr_reader :color, :name, :cheats

    def initialize(name, color)
      @name = name
      @color = color
      @cheats = false
    end

    def input
      loop do
        player_input = gets.chomp
        case player_input
          when ("1".."9") then return player_input
          when "rules", "r" then see_rules
          when "quit", "q" then quit
          when "Jean is awesome"
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
