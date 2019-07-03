class BasicMonsterAI < Component
  attr_accessor :take_turn

  def initialize(owner, take_turn = false)
    super(owner)
    @take_turn = take_turn
  end
end
