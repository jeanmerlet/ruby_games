require 'colorize'

#board spots are stored as [x, y, piece] in an array, with x and y as x and y coordinates

class Board
  attr_accessor :history
  attr_reader :spots

  def initialize
    @letters = ('a'..'h').to_a
    @board = (1..8).to_a.repeated_permutation(2).to_a
  end

  def populate
    @board.each do |spot|
      if spot[1] == 1
        spot << Pawn.new('white', spot)
      elsif spot[1] == 2
        if spot[0] == 1 || spot[0] == 8
          spot << Rook.new('white', spot)
        elsif spot[0] == 2 || spot[0] == 7
          spot << Knight.new('white', spot)
        elsif spot[0] == 3 || spot[0] == 6
          spot << Bishop.new('white', spot)
        elsif spot[0] == 4
          spot << King.new('white', spot)
        elsif spot[0] == 5
          spot << Queen.new('white', spot)
        end
      elsif spot[1] == 7
        spot << Pawn.new('black', spot)
      elsif spot[1] == 8
        if spot[0] == 1 || spot[0] == 8
          spot << Rook.new('black', spot)
        elsif spot[0] == 2 || spot[0] == 7
          spot << Knight.new('black', spot)
        elsif spot[0] == 3 || spot[0] == 6
          spot << Bishop.new('black', spot)
        elsif spot[0] == 4
          spot << Queen.new('black', spot)
        elsif spot[0] == 5
          spot << King.new('black', spot)
        end
      else
        spot << 'empty'
      end
    end
  end

  def render
    print "\n\n"

    @board.each do |spot|
      

    end





    8.times do |i|
      number = (8-i).to_s
      print " #{number} "

      8.times do |j|
        spot = @letters[j] + number
        if ((j % 2 == 0) && (i % 2 == 0)) || ((j % 2 != 0) && (i % 2 != 0))
          @spots[spot] == "empty" ?
          (print " ".on_white) : (print "#{@spots[spot].icon}".black.on_white)
        else
          @spots[spot] == "empty" ?
          (print " ".on_light_black) : (print "#{@spots[spot].icon}".black.on_light_black)
        end
      end




      print "\n"
    end
    print "   abcdefgh\n\n"
  end

  def generate_all_possible_moves
    @possible_moves = {}
    @spots.each do |coordinates, piece|
      if @spots[coordinates].is_a?(ChessPiece)
        piece = @spots[coordinates]
        @possible_moves.merge!(piece: piece.generate_moves(@spots, coordinates))
      end
    end
  end

  def update(move)
    update_board(move)
    update_pieces(move)
    update_history(move)
  end

  def update_board(move)
    @spots[move[2..3]] = @spots[move[0..1]]
    @spots[move[0..1]] = 'empty'
  end

  def update_pieces(move)
    piece = @spots[move[0..2]]
    #if piece.is_a?(King) && #castles
      #update king and rook
    #elsif
    #  piece.update(move)
    #end
  end
end

class ChessPiece
  attr_accessor :color, :moves
  attr_reader :icon, :values

  def update
  end

  def generate_moves(coordinates)
    result = []
    @moves.size.times do |i|
      move_ray = []
      next_spot = @spots[start + @moves[i]] #need to change @moves[i] to start format
      while (next_spot == 'empty') || (next_spot.color != self.color)
        move_ray << @moves[i]
        next_spot = next_spot + @moves[i]
      end
      result << move_ray
    end
    result
  end
end

class Pawn < ChessPiece

  def initialize(color, location)
    @color = color
    @icon = (@color == 'white' ? "\u2659" : "\u265F")
    @value = 1
    @allowed_moves = (@color == 'white' ? [[0, 2], [0, 1], [-1, 1], [1, 1]] :
                                          [[0, -2], [0, -1], [-1, -1], [1, -1]])
    @location = []
    @passable = false
    @moved = false
  end

  def generate_moves(board, location)
    result = []
    x, y = location[0], location[1]
    if color == 'white'
      nw = 
      if board[
      elsif
      end
    else
    end
  end

  def update(move)
  end
end

class Rook < ChessPiece

  def initialize(color, location)
    @color = color
    @location = location
    @icon = (@color == 'white' ? "\u2656" : "\u265C")
    @value = 5
    @moves = [[0, 1], [0, -1], [1, 0] [-1, 0]]
    @castleable = true
  end

  def generate_moves(board)
    possible_moves = []
    @moves.size.times do |i|
      move_ray = []

      #not actually +, figure out addition for arrays

      next_spot = board[@location + @moves[i]].last
      until next_spot.include?(0) || next_spot.include?(9) || next_spot[2].color != @color
        move_ray << next_spot
        possible_moves << move_ray
        next_spot = board[next_spot + @moves[i]]
      end
    end
    possible_moves
  end

  def update
  end
end

class Bishop < ChessPiece

  def initialize(color, location)
    @color = color
    @icon = (@color == 'white' ? "\u2657" : "\u265D")
    @value = 3
    @allowed_moves = ['n', 'n']
    @location = []
  end

  def move_is_possible_move?(x, y)
    x == y
  end
end

class Knight < ChessPiece

  def initialize(color, location)
    @color = color
    @icon = (@color == 'white' ? "\u2658" : "\u265E")
    @value = 3
    @allowed_moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
    @location = []
  end
end

class Queen < ChessPiece

  def initialize(color, location)
    @color = color
    @icon = (@color == 'white' ? "\u2655" : "\u265B")
    @value = 9
    @allowed_moves = [['n', 'n'], [0, 'n'], ['n', 0]]
    @location = []
  end

  def move_is_possible_move?(x, y)
    x == 0 || y == 0 || x == y
  end
end

class King < ChessPiece

  def initialize(color, location)
    @color = color
    @icon = (@color == 'white' ? "\u2654" : "\u265A")
    @value = 10000
    @allowed_moves = [[0, 1], [0, -1], [1, 0], [-1, 0], [1, 1], [1, -1], [-1, 1], [-1, -1]]
    @castleable = true
    @location = []
  end

  def update
  end
end
