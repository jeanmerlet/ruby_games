class Log
  attr_accessor :savefile

  def initialize
    @savefile = File.open('game.pgn', 'w+') {|f|}
    @round = 1
    @letter_index = ("a".."h").to_a
  end

  def record_move(board, player, origin, destination, promotion = "")
    piece = board.spots[origin]
    target_spot = board.spots[destination]
    File.open('game.pgn', 'a') do |file|
      if player.color == 'W'
        file.write("\n#{@round}. ")
        @round += 1
      end

      piece_letter = piece.letter
      piece_letter << disambiguation(board, piece, origin, destination)
      capture = (board.spots[destination] == 0 ? "" : "x")
      rankfile = @letter_index[destination[0] - 1].to_s + destination[1].to_s

      file.write("#{piece_letter}#{capture}#{rankfile}#{promotion} ")
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
