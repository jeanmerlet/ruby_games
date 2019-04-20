class Serialize

  def initialize
  end

  def load_game(filename)
    @logger.change_file(filename)
    data = read_file(filename)
    data = standardize_file_format(data)
    bring_game_current(data)
  end

  def standardize_file_format(data)
    data
  end

  def read_file(filename)
    File.read(filename)
  end

  def bring_game_current(data, render = true)
    rounds = data.scan(/(\d+[.]\s?\S+\s\S+)/).flatten
    rounds.each do |round|
      moves = round.scan(/[.]\s?(\S+)\s(\S+)/).flatten
      moves.each do |move|
        move = parse_SAN(move)
        origin, destination = move[0], move[1]
        @logger.record_move(@board, player, origin, destination)
        @board.update(origin, destination, @logger)
        @board.render if render
      end
    end
    #round = "latestroundinthefile, ofcourse"
  end
end

class Logger
  attr_accessor :savefile, :uncommon

  def initialize
    @savefile = File.open('game.pgn', 'w+')
    @filename = 'game.pgn'
    @round = 1
    @letter_index = ("a".."h").to_a
    @uncommon = { promotion: false, castle: false, check: false, checkmate: false, en_passant: false }
  end

  def change_file(filename)
    @savefile = File.open(filename, 'w+')
    @filename = filename
  end

  def record_move(board, player, origin, destination)
    piece = board.spots[origin]
    target_spot = board.spots[destination]

    File.open('game.pgn', 'a') do |file|
      if player.color == 'W'
        file.write("\n#{@round}. ")
        @round += 1
      end

      letter = piece.letter
      letter << disambiguation(board, piece, origin, destination)

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

      if @uncommon[:castle]
        file.write("#{@uncommon[:castle]} ")
      else
        file.write("#{letter}#{capture}#{rankfile}#{promotion}#{check} ")
      end
    end
    reset_uncommon
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
