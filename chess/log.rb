class Log
  attr_accessor :savefile

  def initialize
    @savefile = File.open('game.pgn', 'w+') {|f|}
    @round = 1
    @markers = ['x', '=', '+', '#', 'O-O', 'O-O-O']
  end

  def record_move(board, player, move)
    origin = move[0]
    destination = move[1]
    piece = board.spots[origin]
    File.open('game.pgn', 'a') do |file|
      if player.color == 'W'
        file.write("\n#{@round}. ")
        @round += 1
      end
      if disambiguation_needed?(board, piece, origin, destination)
      end
      file.write("#{piece}")
    end
  end
  def disambiguation_needed?(board, piece, origin, destination)
    8.times do 
      board.spots[]
    end
  end
end
