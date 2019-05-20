class Player
  attr_accessor :name, :pieces
  attr_reader :color, :pretty_color

  def initialize(color)
    @color = color
    @pretty_color = (@color == 'W' ? "white" : "black")
    @name = @pretty_color.dup
    @pieces = 16
    setup if self.is_a?(AI)
  end
end

class Human < Player

  def take_turn(board)
    puts "#{@name}'s turn:"
    loop do
      input = gets.chomp
      case input
      when /\A[a-h][1-8][a-h][1-8]\z/ then return input
      when "draw", "quit" then return input
      else
        puts "Incorrect input format. ex: a2a4"
      end
    end
  end

  def pawn_promote
    puts "Enter pawn promotion (one of BNRQ):"
    loop do
      input = gets.chomp
      case input
      when 'B', 'N', 'R', 'Q' then return input
      end
    end
  end

  def name_player
    puts "Enter name for #{@pretty_color}:"
    loop do
      input = gets.chomp
      if /\A[A-Za-z]{2,35}[ ]?[A-Za-z]{2,35}\z/ === input
        @name = input
        break
      elsif input == ""
        break
      else
        puts "Invalid name format."
      end
    end
  end

  def accept_draw?
    puts "Draw proposed. Do you accept? (y)es or (n)o."
    loop do
      input = gets.chomp
      case input
      when "y", "yes" then return true
      when "n", "no"  then return false
      end
    end
  end
end

class AI < Player

  def setup
    @name = "Rob Berto"
  end

  def take_turn(board)
    loop do
      file = 1 + rand(7)
      rank = 1 + rand(7)
      origin = [file, rank]
      piece = board.spots[origin]
      if piece != 0 && piece.color == @color
        moves = piece.generate_moves(board, origin, true)
        if moves != []
          print "origin:"
          p origin
          destination = moves[rand(moves.size)]
          print "destination:"
          p destination
          return [origin, destination]
        end
      end
    end
  end

  def pawn_promote
    'Q'
  end

  def name_player
  end

  def accept_draw?
    true
  end
end
