class Serialize

  def initialize
  end

  def restore(filename, logger)
    data = File.read(filename).gsub(/[\n\r]/, "")
    tags = data.scan(/(\[[A-Za-z]+\s"[A-Za-z]+"\])/).flatten
    rounds = data.scan(/\d+[.]\s?(\S+\s\S+)/).flatten
    moveset = []
    logger.import_tags(tags)
    rounds.each_with_index do |round, i|
      moveset << round.scan(/(\S+)\s(\S+)/).flatten
    end
    moveset
  end
end

class Logger
  attr_accessor :savefile, :tokens, :symbols

  def initialize
    @savefile = File.open('game.pgn', 'w+')
    @filename = 'game.pgn'
    @tokens = { promotion: false, castle: false, check: false, en_passant: false, end_game: false }
  end

  def write_default_tags
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

  def import_tags(tags)
    File.open(@filename, 'a') do |file|
      tags.each { |tag| file.write("#{tag}\n") }
    end
  end

  def write_names(white, black)
    File.open(@filename, 'a' do |file|
    end
  end

  def record_move(board, round, player, origin, destination)
    piece = board.spots[origin]
    target_spot = board.spots[destination]

    File.open(@filename, 'a') do |file|
      file.write("\n#{round}. ") if player.color == 'W'
      letter = piece.letter
      letter << disambiguation(board, piece, origin, destination)
      capture, rankfile, promotion, check = *assign_values(board, destination)

      if @tokens[:castle]
        file.write("#{@tokens[:castle]} ")
      else
        file.write("#{letter}#{capture}#{rankfile}#{promotion}#{check} ")
      end
      file.write("#{@tokens[:end_game]}") if @tokens[:end_game]
    end
    reset_tokens
  end

  def assign_values(board, destination)
    capture = (board.spots[destination] == 0 ? "" : "x")
    capture = "x" if @tokens[:en_passant]
    rankfile = @@letter_index[destination[0] - 1].to_s + destination[1].to_s
    promotion = (@tokens[:promotion] ? ("=" + @tokens[:promotion]) : "")
    check = (@tokens[:check] ? @tokens[:check] : "")
    [capture, rankfile, promotion, check]
  end

  def reset_tokens
    @token.each do |flag, value|
      @token[flag] = false
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
        file = @@letter_index[origin[0]-1] if spot[0] != origin[0]
        rank = origin[1].to_s if spot[1] != origin[1]
      end
    end
    (file + rank)
  end
end
