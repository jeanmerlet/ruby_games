class Combat < Component
  attr_accessor :hp
  attr_reader :max_hp, :defense, :power

  def initialize(owner, hp, defense, power)
    super(owner)
    @hp, @max_hp = hp, hp
    @defense, @power = defense, power
  end
end
