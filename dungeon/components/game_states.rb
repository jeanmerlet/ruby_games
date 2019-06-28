class GameStates
  attr_reader :player_turn, :enemy_turn

  def initialize
    @player_turn = 1
    @enemy_turn = 2
  end
end
