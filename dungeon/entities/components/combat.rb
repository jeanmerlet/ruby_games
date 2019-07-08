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
    results.push({ death: @owner }) if @hp <= 0
    return results
  end

  def attack(target)
    results = []
    damage = @power - target.combat.defense
    owner_name = "[color=#{@owner.color}]#{@owner.name.capitalize}[/color]"
    target_name = "[color=#{target.color}]#{target.name}[/color]"
    if damage > 0
      results.push({ message: "#{owner_name} hits #{target_name} for #{damage} damage." })
      results.push(target.combat.take_damage(damage))
      results.flatten!
    else
      results.push({ message: "#{owner_name} attacks #{target_name} but does no damage." })
    end
    return results
  end
end
