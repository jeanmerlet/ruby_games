class Serialize
  def restore(filename, logger)
    tags, rounds = *read_tags_and_moves(filename)
    logger.import_tags(tags)
    rounds = rounds.scan(/\d+\.\s?(\S+[ ]{1,2}\S+)/).flatten
    moveset = []
    rounds.each {|round| moveset << round.scan(/(\S+)[ ]{1,2}(\S+)/).flatten }
    moveset << tags.scan(/\[Result \"(\S+)\"\]/).flatten
    print moveset
    moveset
  end

  def read_tags_and_moves(filename)
    tags, rounds = [], []
    File.foreach(filename, "\r\n\r\n").with_index do |blob, i|
      tags = blob if i == 0
      rounds = blob if i == 1
    end
    [tags, rounds]
  end
end

class Logger
  attr_accessor :savefile, :tokens, :symbols

  def initialize
    File.open('game.pgn', 'w+') {|file| }
    @filename = 'game.pgn'
    @tokens = { promotion: false, castle: false, check: false, en_passant: false, end_game: false }
  end

  def write_default_tags
    time = Time.new
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
    File.open(@filename, 'a') {|file| file.write(tags) }
  end

  def write_names(white_name, black_name)
    File.open(@filename, 'a') do |file|
    end
  end

  def record_move(board, round, player, origin, destination)
    piece = board.spots[origin]
    target_spot = board.spots[destination]

    File.open(@filename, 'a') do |file|
      file.write("#{round}. ") if player.color == 'W'
      capture, rankfile, promotion, check = *assign_values(board, destination)
      letter = piece.letter.dup
      letter << disambiguation(board, piece, origin, destination)
      letter << @@letter_index[origin[0]-1] if letter == "" && capture == "x"

      if @tokens[:castle]
        file.write("#{@tokens[:castle]} ")
        puts("\n#{@tokens[:castle]} ")
      else
        file.write("#{letter}#{capture}#{rankfile}#{promotion}#{check} ")
        puts("\n#{letter}#{capture}#{rankfile}#{promotion}#{check} ")
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
    @tokens.each do |flag, value|
      @tokens[flag] = false
    end
  end

  def disambiguation(board, moving_piece, origin, destination)
    spots = board.spots
    file, rank = @@letter_index[origin[0]-1], origin[1].to_s
    file_needed, rank_needed = false, false

    spots.each do |spot, piece|
      next if spot == origin
      current_piece = spots[spot]
      if current_piece != 0 &&
      current_piece.color == moving_piece.color &&
      current_piece.letter == moving_piece.letter &&
      current_piece.generate_moves(board, spot).include?(destination)
        if spot[0] != origin[0]
          file_needed = true
        else
          rank_needed = true
        end
      end
    end

    if !file_needed && !rank_needed
      file, rank = "", ""
    elsif !file_needed
      file = ""
    elsif !rank_needed
      rank = ""
    end
    file + rank
  end
end
