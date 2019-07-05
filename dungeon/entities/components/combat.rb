class Combat < Component
  attr_accessor :hp
  attr_reader :max_hp, :defense, :power

  def initialize(owner, hp, defense, power)
    super(owner)
    @hp, @max_hp = hp, hp
    @defense, @power = defense, power
  end

  def take_damage(amount)
    results = []
    @hp -= amount
    results.push({ dead: @owner }) if @hp <= 0
    return results
  end

  def attack(target)
    results = []
    damage = @power - target.combat.defense
    if damage > 0
      results.push({ message: "#{owner.name.capitalize} hits #{target.name} for #{damage} damage!" })
      results.push(target.combat.take_damage(damage))
      results.flatten!
    else
      results.push({ message: "#{owner.name.capitalize} attacks #{target.name} but does no damage." })
    end
    return results
  end
end
