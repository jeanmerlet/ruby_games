class Fighter
  attr_reader :hp, :max_hp, :defense, :power

  def initialize(hp, defense, power)
    @hp, @max_hp = hp, hp
    @defense = defense
    @power = power
  end
end
