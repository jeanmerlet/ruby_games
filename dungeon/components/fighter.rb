class Fighter
  attr_accessor :hp
  attr_reader :max_hp, :defense, :power

  def initialize(hp, defense, power)
    @hp, @max_hp = hp, hp
    @defense = defense
    @power = power
  end
end
