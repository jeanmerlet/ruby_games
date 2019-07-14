class Heal
  attr_accessor :amount

  def initialize(owner, amount)
    @owner = owner
    @amount = amount
  end

  def do(target)
    results = []
    if target.combat && target.combat.hp[0] != target.combat.hp[1]
      target.combat.take_damage(-amount)
      results.push({ message: "The [color=#{@owner.color}]#{@owner.name}[/color] heals you for #{amount}."})
    else
      results.push({ message: "The [color=#{@owner.color}]#{@owner.name}[/color] has no effect."})
    end
    return results
  end
end
