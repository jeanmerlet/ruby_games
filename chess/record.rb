class Serialize
  def restore(filename, logger, black, white)
    tags, rounds = *read_tags_and_moves(filename)

    restore_names(tags, white, black)
    logger.import_tags(tags_to_roster(tags))

    rounds = rounds_to_string(rounds)
    turns = rounds.scan(/\d+\.\s?(\S+[ ]{1,2}\S+)/).flatten
    half_turn = rounds.scan(/\d+\.\s?(\S+[ ]{1,2})\z/).flatten
    if half_turn != []
      half_turn[0] << tags.scan(/\[Result \"(\S+)\"\]/).flatten[0]
      turns << half_turn[0]
    end
    moveset = []
    turns.each {|turn| moveset << turn.scan(/(\S+)[ ]{1,2}(\S*)/).flatten }
    moveset << get_result(tags)
    moveset
  end

  def read_tags_and_moves(filename)
    tags, rounds = [], []
    swap = false
    File.foreach(filename, chomp: true) do |line|
      if swap == false && line != ""
        tags << line
      elsif swap == false && line == ""
        swap = true
      else
        rounds << line
      end
    end
    [tags, rounds]
  end

  def restore_names(tags, white, black)
    tags.each do |tag|
      if /White / === tag
        white.name = tag.scan(/\"(.+)\"/).flatten.first
      elsif /Black / === tag
        black.name = tag.scan(/\"(.+)\"/).flatten.first
      end
    end
  end

  def tags_to_roster(tags)
    new_tags = ""
    tags.each {|tag| new_tags << tag + "\n"}
    new_tags
  end

  def rounds_to_string(rounds)
    new_rounds = ""
    rounds.each {|round| new_rounds << (round + " ")}
    new_rounds
  end

  def get_result(tags)
    tags.each do |tag|
      return tag.scan(/\"(.+)\"/).flatten if /Result/ === tag
    end
  end
end

class Logger
  attr_accessor :savefile, :tokens, :symbols

  def initialize(filename = 'game.pgn.tmp')
    @newline = 0
    File.open(filename, 'wt') {|file|}
    @filename = filename
    @tokens = { promotion: false, castle: false, check: false, en_passant: false, end_game: false }
  end

  def save
    game = File.read(@filename, mode: 'rt')
    File.open('game.pgn', 'wt') do |file|
      file.write(game)
    end
    File.delete(@filename)
  end

  def write_default_tags(white_name, black_name)
    time = Time.new
    File.open(@filename, 'at') do |file|
      file.write("[Event \"casual game\"]\n")
      file.write("[Site \"Knoxville, TN USA\"]\n")
      file.write("[Date \"#{time.year}.#{time.month}.#{time.day}\"]\n")
      file.write("[Round \"-\"]\n")
      file.write("[White \"#{white_name}\"]\n")
      file.write("[Black \"#{black_name}\"]\n")
      file.write("[Result \"*\"]\n\n")
    end
  end

  def import_tags(tags)
    File.open(@filename, 'at') {|file| file.write("#{tags}\n") }
  end

  def record_move(board, round, player, opponent, origin, destination)
    piece = board.spots[origin]

    File.open(@filename, 'at') do |file|
      if @tokens[:end_game]
        file.write(" #{@tokens[:end_game]}\n")
        break
      end
      if player.color == 'W'
        move = "#{round}. "
        newline_check(move, file)
        file.write(move)
      end
      capture, rankfile, promotion, check = *assign_values(board, destination)
      letter = piece.letter.dup
      letter << disambiguation(board, piece, origin, destination)
      letter << $letter_index[origin[0]-1] if letter == "" && capture == "x"

      if @tokens[:castle]
        move = "#{@tokens[:castle]}#{check} "
      elsif @tokens[:promotion]
        move = "#{rankfile}#{promotion}#{check} "
      else
        move = "#{letter}#{capture}#{rankfile}#{promotion}#{check} "
      end
      #puts move
      newline_check(move, file)
      file.write(move)
      opponent.pieces -= 1 if capture == "x"
    end
    reset_tokens
  end

  def assign_values(board, destination)
    capture = (board.spots[destination] == 0 ? "" : "x")
    capture = "x" if @tokens[:en_passant]
    rankfile = $letter_index[destination[0] - 1].to_s + destination[1].to_s
    promotion = (@tokens[:promotion] ? ("=" + @tokens[:promotion]) : "")
    check = (@tokens[:check] ? @tokens[:check] : "")
    [capture, rankfile, promotion, check]
  end

  def record_game_result
    game = ""
    File.open(@filename, 'at') {|file| file.write(" #{@tokens[:end_game]}\n\n")}
    File.open(@filename, 'rt') do |file|
      game = File.read(file)
      game.sub!(/"\*"/, "\"#{@tokens[:end_game]}\"")
    end
    File.open(@filename, 'wt') {|file| file.write(game)}
  end

  def newline_check(move, file)
    @newline += move.size
    if @newline >= 80
      file.write("\n")
      @newline = move.size
    end
  end

  def reset_tokens
    @tokens.each do |flag, value|
      @tokens[flag] = false
    end
  end

  def disambiguation(board, moving_piece, origin, destination)
    spots = board.spots
    file, rank = $letter_index[origin[0]-1], origin[1].to_s
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
