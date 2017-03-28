require 'colorize'

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
      if spot =~ /7/              then Pawn.new('black')
      elsif spot =~ /2/           then Pawn.new('white')
      elsif spot =~ /8/
        if spot =~ /[a, h]/       then Rook.new('black')
        elsif spot =~ /[b, g]/    then Knight.new('black')
        elsif spot =~ /[c, f]/    then Bishop.new('black')
        elsif spot =~ /d/         then Queen.new('black')
        elsif spot =~ /e/         then King.new('black')
        end
      elsif spot =~ /1/
        if spot =~ /[a, h]/       then Rook.new('white')
        elsif spot =~ /[b, g]/    then Knight.new('white')
        elsif spot =~ /[c, f]/    then Bishop.new('white')
        elsif spot =~ /d/         then Queen.new('white')
        elsif spot =~ /e/         then King.new('white')
        end
      else
        'none'
      end
    end
  end

  def render
    print "\n\n"
    8.times do |i|
      number = (8-i).to_s
      print " #{number} "

      8.times do |j|
        spot = @letters[j] + number
        if ((j % 2 == 0) && (i % 2 == 0)) || ((j % 2 != 0) && (i % 2 != 0))
          @spots[spot] == "none" ?
          (print " ".on_white) : (print "#{@spots[spot].icon}".black.on_white)
        else
          @spots[spot] == "none" ?
          (print " ".on_light_black) : (print "#{@spots[spot].icon}".black.on_light_black)
        end
      end

      print "\n"
    end
    print "   abcdefgh\n\n"
  end

  def update(move)
    update_board(move)
    update_pieces(move)
    update_history(move)
  end

  def update_board(move)
    @spots[move[2..3]] = @spots[move[0..1]]
    @spots[move[0..1]] = 'none'
  end

  def update_pieces(move)
    piece = @spots[move[0..2]]
    #if piece.is_a?(King) && #castles
      #update king and rook
    #elsif
    #  piece.update(move)
    #end
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

  class GamePiece

    attr_accessor :color, :allowed_moves
    attr_reader :icon, :values

    class Pawn
      attr_accessor :color, :allowed_moves
      attr_reader :icon, :values

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2659" : "\u265F")
        @value = 1
        @allowed_moves = (@color == 'white' ? [[0, 2], [0, 1], [-1, 1], [1, 1]] :
                                              [[0, -2], [0, -1], [-1, -1], [1, -1]])
        @first_move = false
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

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2656" : "\u265C")
        @value = 5
        @allowed_moves = [[0, 'n'], ['n', 0]]
        @castleable = true
      end

      def update
      end
    end

    class Bishop
      attr_accessor :color
      attr_reader :icon, :value, :allowed_moves

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2657" : "\u265D")
        @value = 3
        @allowed_moves = ['n', 'n']
      end

      def update
      end
    end

    class Knight
      attr_accessor :color
      attr_reader :icon, :value, :allowed_moves

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2658" : "\u265E")
        @value = 3
        @allowed_moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
      end

      def update
      end
    end

    class Queen
      attr_accessor :color
      attr_reader :icon, :value, :allowed_moves

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2655" : "\u265B")
        @value = 9
        @allowed_moves = [['n', 'n'], [0, 'n'], ['n', 0]]
      end

      def update
      end
    end

    class King
      attr_accessor :color
      attr_reader :icon, :value, :allowed_moves

      def initialize(color)
        @color = color
        @icon = (@color == 'white' ? "\u2654" : "\u265A")
        @value = 10000
        @allowed_moves = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
        @castleable = true
      end

      def update
      end
    end
  end
end
