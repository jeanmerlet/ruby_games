class Serialize

  def initialize
    @letter_index = ("a".."h").to_a
  end

  def restore(filename, board, white, black, logger)
    #logger.change_savefile(filename)
    data = File.read(filename)
    data.gsub!(/[\n\r]/, "")
    bring_game_current(data, board, white, black, logger)
  end

  def bring_game_current(data, board, white, black, logger, render = true)
    rounds = data.scan(/(\d+[.]\s?\S+\s\S+)/).flatten
    rounds.each do |round|
      move_pair = round.scan(/[.]\s?(\S+)\s(\S+)/).flatten
      player = white
      move_pair.each do |move|
        move = parse_SAN(move, board, player)
        origin, destination = move[0], move[1]
        logger.record_move(board, player, origin, destination)
        board.update(origin, destination, logger)
        board.render if render
        player = black
      end
    end
    logger.round = rounds[-1].match(/[\d]+/).first
  end

  def parse_SAN(move, board, player)
    move_parts = move.scan(/([BNRKQ]?)([a-h]?\d?)x?([a-h]\d)\S?/).flatten
    piece = move_parts[0]
    origin_file_rank = move_parts[1]
    destination_file_rank = move_parts[2]

    destination = [@letter_index.index(destination_file_rank[0]) + 1, destination_file_rank[1]]
    if !origin_file_rank =~ /\A[a-h][1-8]\z/
      origin_file_rank = board.find_SAN_piece(piece, player.color, origin_file_rank, destination)
    end
    
    "#{origin_file_rank}#{destination_file_rank}"
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

  def change_savefile(filename)
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
