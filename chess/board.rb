class Board

  def initialize
    coordinates = []
    ('a'..'h').to_a.each do |x|
      8.times.with_index { |i| coordinates << x + (i+1).to_s }
    end
    @spots = coordinates.product([0]).to_h
  end

  def populate
    @spots.update(@spots) do |spot, piece|
      if spot =~ /[2, 7]/         then Pawn.new
      elsif spot =~ /[1,8]/
        if spot =~ /[a, h]/       then Rook.new
        elsif spot =~ /[b, g]/    then Knight.new
        elsif spot =~ /[c, f]/    then Bishop.new
        elsif spot =~ /(d1|e8)/  then Queen.new
        elsif spot =~ /(e1|d8)/  then King.new
        end
      else
        'none'
      end
    end
    @spots.each_key do |spot|
      if spot =~ /[7, 8]/ then @spots[spot].color = 'black'
      elsif spot =~ /[1, 2]/ then @spots[spot].color = 'white'
      end
    end
  end

  def render
    print "\n   --------\n"
    letters = ('a'..'h').to_a
    8.times do |i|
      number = (8-i).to_s
      print " #{number}|"

      8.times do |j|
        spot = letters[j] + number
        @spots[spot] == "none" ? print(" ") : print("#{@spots[spot].icon}")
      end

      print "|\n"
    end
    print "   --------\n"
    print "   abcdefgh\n\n"
  end

  def update(move)
  end

  class Pawn
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "P"
      @value = 1
      @allowed_moves = ''
      @color = ''
      @passable = false
    end
  end

  class Rook
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "R"
      @value = 5
      @allowed_moves =
      @color = ''
      @castleable = true
    end
  end

  class Bishop
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "B"
      @value = 3
      @allowed_moves =
      @color = ''
    end
  end

  class Knight
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "N"
      @value = 3
      @allowed_moves =
      @color = ''
    end
  end

  class Queen
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "Q"
      @value = 9
      @allowed_moves =
      @color = ''
    end
  end

  class King
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "K"
      @value = 10000
      @allowed_moves =
      @color = ''
      @castleable = true
    end
  end

end
