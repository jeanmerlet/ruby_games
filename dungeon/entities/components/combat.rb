class Combat
  attr_accessor :hp, :ac
  attr_reader :defense, :power

  def initialize(owner, hp, defense, power)
    @owner = owner
    @hp = [hp, hp]
    @dodge = 10 + @owner.stats.mod(@owner.stats.guil) if @owner.name == 'player'
    @ac = 14 #future kevlar
    @shields, @shield_regen = 30, 3
    @defense, @power = defense, power
  end

  def take_damage(amount)
    results = []
    @hp[0] -= amount
    @hp[0] = @hp[1] if @hp[0] > @hp[1]
    results.push({ death: @owner }) if @hp.first <= 0
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
