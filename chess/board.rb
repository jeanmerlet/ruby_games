class Board
  attr_accessor :history
  attr_reader :spots

  def initialize
    coordinates = []
    @letters = ('a'..'h').to_a
    @letters.each do |x|
      8.times.with_index { |i| coordinates << x + (i+1).to_s }
    end
    @spots = coordinates.product([0]).to_h
    @history = []
  end

  def populate
    @spots.update(@spots) do |spot, piece|
      if spot =~ /[2, 7]/         then Pawn.new
      elsif spot =~ /[1,8]/
        if spot =~ /[a, h]/       then Rook.new
        elsif spot =~ /[b, g]/    then Knight.new
        elsif spot =~ /[c, f]/    then Bishop.new
        elsif spot =~ /(d1|e8)/   then Queen.new
        elsif spot =~ /(e1|d8)/   then King.new
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
    @spots.each_key do |spot|       #swap allowed moves for black pawns
      if spot =~ /[7]/
        @spots[spot].allowed_moves = @spots[spot].allowed_moves.map do |x|
          x.map {|x| x*-1}
        end      
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
    update_board(move)
    update_pieces(move)
    update_history(move)
  end

  def update_board
    @spots[move[2..3]] = @spots[move[0..1]]
    @spots[move[0..1]] = 'none'
  end

  def update_pieces(move)
    piece = @spots[move[0..2]]
    if piece.is_a?(King) && #castles
      #update king and rook
    else
      piece.update(move)
    end    
  end

  def update_history(move)
  end

  def check
    true
  end

  def checkmate
    false
  end

  def tie
    false
  end

  class Pawn
    attr_accessor :color, :allowed_moves
    attr_reader :icon, :values

    def initialize
      @icon = "P"
      @value = 1
      @allowed_moves = [[0, 2], [0, 1], [-1, 1], [1, 1]]
      @color = ''
      @moved = false
      @passable = false
    end

    def update(move)
      @allowed_moves.delete_at(0) if @allowed_moves.length == 4

      #need to check pawn moved 2 before checking for passable

      spot = move[2..3]
      left = @letters.index(@letters.index(spot[0]) - 1) + spot[1] unless spot[0] == 'a'
      right = @letters.index(@letters.index(spot[0]) + 1) + spot[1] unless spot[0] == 'h'
      @passable = true if @spots[left].is_a?(Pawn) && @spots[left].color != @color
      @passable = true if @spots[right].is_a?(Pawn) && @spots[right].color != @color

      #need to check for passable to allow diagonal capture in validate method
      #
      #also need to do pawn upgrading...
    end
  end

  class Rook
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "R"
      @value = 5
      @allowed_moves = [[0, 'n'], ['n', 0]]
      @color = ''
      @castleable = true
    end

    def update
    end
  end

  class Bishop
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "B"
      @value = 3
      @allowed_moves = ['n', 'n']
      @color = ''
    end

    def update
    end
  end

  class Knight
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "N"
      @value = 3
      @allowed_moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
      @color = ''
    end

    def update
    end
  end

  class Queen
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "Q"
      @value = 9
      @allowed_moves = [['n', 'n'], [0, 'n'], ['n', 0]]
      @color = ''
    end

    def update
    end
  end

  class King
    attr_accessor :color
    attr_reader :icon, :value, :allowed_moves

    def initialize
      @icon = "K"
      @value = 10000
      @allowed_moves = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
      @color = ''
      @castleable = true
    end

    def update
    end
  end

end
