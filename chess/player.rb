class Player
  attr_accessor :name
  attr_reader :color, :pretty_color
end

class Human < Player

  def initialize(color)
    @color = color
    @pretty_color = (@color == 'W' ? "white" : "black")
    @name = @pretty_color.dup
  end

  def take_turn
    puts "#{@name}'s turn:"
    loop do
      input = gets.chomp
      case input
      when /\A[a-h][1-8][a-h][1-8]\z/ then return input
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
end

class AI < Player

  def initialize(color)
    @color = color
    @pretty_color = (@color == 'W' ? "white" : "black")
    @difficulty = 0
    @name = "Rob Berto"
  end

  def take_turn
  end

  def pawn_promote
  end
end
