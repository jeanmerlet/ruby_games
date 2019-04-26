class Player
  attr_accessor :name
  attr_reader :color
end

class Human < Player

  def initialize(color)
    @color = color
    @pretty_color = (@color == 'W' ? "white" : "black")
  end

  def take_turn
    puts "#{@pretty_color}'s turn:"
    loop do
      input = gets.chomp
      case input
      when /\A[a-h][1-8][a-h][1-8]\z/ then return input
      else
        puts "incorrect input format. ex: a2a4"
      end
    end
  end

  def pawn_promote
    puts "enter pawn promotion (one of BNRQ):"
    loop do
      input = gets.chomp
      case input
      when 'B', 'N', 'R', 'Q' then return input
      end
    end
  end

  def name
    puts "enter name for #{@pretty_color}:"
    loop do
      input = gets.chomp
      @name = input if /\A[a-z]{2, 35}\s[a-z]{2, 35}\z/ === input
    end
  end
end

class AI < Player

  def initialize(color)
    @color = color
    @difficulty = 0
    @name = "Rob Berto"
  end

  def take_turn
  end

  def pawn_promote
  end
end
