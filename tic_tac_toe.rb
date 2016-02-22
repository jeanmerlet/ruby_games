class TicTacToe

  def initialize
    puts "\nWelcome to Ruby-Powered, Command-Line Tic-Tac-Toe!"
    @board = Board.new
    new_players
  end

  def new_players
    @player_one = Player.new(name_player(1), "X", @board)
    @player_two = Player.new(name_player(2), "O", @board)
  end

  def name_player(number)
    puts "\nEnter a name for player #{number}:"
    name = gets.chomp
  end

  def start
    @board.display(@board.rule_spots)
    puts "#{@player_one.name} goes first - place an X!"
    puts "Type a number 1-9 as above to place or (r)ules for rules:"
    play(@player_two)
  end

  def play(player)
    until @board.has_win? || @board.is_full? || player.secret_win do
      puts ""
      @board.display(@board.game_spots)
      player = switch_player(player)
      player.input
    end

    if @board.has_win?
      puts "#{player.name} wins!"
    elsif @board.is_full?
      puts "It's a tie..."
    end
    play_again
  end

  def switch_player(player)
    player = (player == @player_one ? @player_two : @player_one)
  end

  def play_again
    puts "Would you like to play again? (y)es or (n)o"
    answer = gets.chomp
    case answer
      when "yes", "y"
        new_players
        @board.new_board
        start
      when "no", "n" then exit
      else play_again
    end
  end

  class Board

    attr_reader :game_spots, :rule_spots

    def initialize
      new_board
      @rule_spots = (1..9).to_a
    end

    def new_board
      @game_spots = Array.new(9, " ")
      @winning_spots = [[0, 1, 2], [0, 4, 8], [0, 3, 6], [1, 4, 7], [2, 4, 6], [2, 5, 8], [3, 4, 5], [6, 7, 8]]
    end

    def update(number, color)
      @game_spots[number.to_i - 1] = color
      @winning_spots.map do |x|
        x.map! { |y| y == (number.to_i - 1) ? y = color : y }
      end
    end

    def display(spots)
      3.times do |j|
        puts "-------"
        3.times { |i| print "|#{spots[i+(j*3)]}" }
        puts "|"
      end
      puts "-------\n\n"
    end

    def has_win?
      @winning_spots.any? { |x| [["X", "X", "X"], ["O", "O", "O"]].include?(x) }
    end

    def is_full?
      @game_spots.none? { |x| x == " " }
    end

  end

  class Player

    attr_reader :color, :board, :name, :secret_win

    def initialize(name, color, board)
      @name = name
      @color = color
      @board = board
      @secret_win = false
    end

    def input
      @placed = false
      until @placed do
        player_input = gets.chomp
        case player_input
          when ("1".."9") then self.place(player_input)
          when "board", "b" then @board.display(@board.game_spots)
          when "who", "w" then puts "#{self.name}\n\n"
          when "rules", "r" then self.see_rules
          when "quit", "q" then quit
          when "cheat"
            cheat
            return
        end
      end
    end

    def place(number)
      if @board.game_spots[number.to_i - 1] == " "
        @board.update(number, self.color)
        @placed = true
      else
        puts "Spot taken!\n\n"
      end
    end

    def see_rules
      @board.display(@board.rule_spots)
      puts "The goal of Tic-Tac-Toe is to get three of your 'color' in a row, the traditional Xs and Os in this case. You and your opponent alternate turns, placing one token on any unoccupied spot. The game ends with either a win for one of the players, or in a tie if no spots are left and neither player has won."
      puts "\nAvailable commands:"
      puts "  1-9       places one of your tokens in the corresponding spot as above"
      puts "  (b)oard   displays the current game board"
      puts "  (w)ho     prints name of player currently taking his turn"
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
      puts "\nYou cheater!\n#{self.name} 'wins'!\n\n"
      @secret_win = true
    end

  end

end

game = TicTacToe.new
game.start
