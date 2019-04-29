class Serialize

  def initialize
    @letter_index = ("a".."h").to_a
  end

  def restore(filename, logger, white, black)
    data = File.read(filename).gsub(/[\n\r]/, "")
    rounds = data.scan(/\d+[.]\s?(\S+\s\S+)/).flatten
    moveset = []
    rounds.each_with_index do |round, i|
      moveset << round.scan(/(\S+)\s(\S+)/).flatten
    end
    moveset
  end
end

class Logger
  attr_accessor :savefile, :uncommon, :symbols

  def initialize
    @savefile = File.open('game.pgn', 'w+')
    @filename = 'game.pgn'
    @letter_index = ("a".."h").to_a
    @tokens = { promotion: false, castle: false, check: false, end_game: false }
    write_default_STR
    @round = 1
  end

  def write_default_STR
    File.open(@filename, 'a') do |file|
      file.write("[Event \"casual game\"]\n")
      file.write("[Site \"Knoxville, TN USA\"]\n")
      file.write("[Date \"#{time.year}.#{time.month}.#{time.day}\"]\n")
      file.write("[Round \"1\"]\n")
      file.write("[White \"?\"]\n")
      file.write("[Black \"?\"]\n")
      file.write("[Result \"*\"]\n\n")
    end
  end

  def write_names(white, black)
    File.open(@filename, 'a' do |file|
    end
  end

  def record_move(board, player, origin, destination)
    piece = board.spots[origin]
    target_spot = board.spots[destination]

    File.open(@filename, 'a') do |file|
      if player.color == 'W'
        file.write("\n#{@round}. ")
        @round += 1
      end

      letter = piece.letter
      letter << disambiguation(board, piece, origin, destination)

      assign_values(board, destination)

      if @uncommon[:castle]
        file.write("#{@uncommon[:castle]} ")
      else
        file.write("#{letter}#{capture}#{rankfile}#{promotion}#{check} ")
        if @uncommon[:checkmate]
          file.write("#{@uncommon[:checkmate]}")
        end
      end
    end
    reset_uncommon
  end

  def assign_values(board, destination)
    capture = (board.spots[destination] == 0 ? "" : "x")
    capture = "x" if @uncommon[:en_passant]
    rankfile = @letter_index[destination[0] - 1].to_s + destination[1].to_s
    if @uncommon[:promotion]
      promotion = ("=" + @uncommon[:promotion])
    else
      promotion = ""
    end
    check = "+" if @uncommon[:check]
    check = "#" if @uncommon[:checkmate]
  end

  def reset_uncommon
    @uncommon.each do |flag, value|
      @uncommon[flag] = false
    end
  end

  def disambiguation(board, moving_piece, origin, destination)
    spots = board.spots
    file, rank = "", ""
    spots.each do |spot, piece|
      next if spot == origin
      current_piece = spots[spot]
      if current_piece != 0 &&
      current_piece.color == moving_piece.color &&
      current_piece.letter == moving_piece.letter &&
      current_piece.generate_moves(board, spot).include?(destination)
        file = @letter_index[origin[0]-1] if spot[0] != origin[0]
        rank = origin[1].to_s if spot[1] != origin[1]
      end
    end
    (file + rank)
  end
end
