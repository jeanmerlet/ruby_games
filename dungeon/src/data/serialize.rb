module Serialize

  def self.save_game(game)
    filename = "./src/data/game.sav"
    File.open(filename, 'wb') { |file| file.write(Marshal.dump(game)) }
  end

  def self.restore(filename)
    return Marshal.load(File.binread(filename))
  end
end
