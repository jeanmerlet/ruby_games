class BasicMonster
  attr_reader :take_turn

  def initialize(take_turn = false)
    @take_turn = take_turn
  end
end
