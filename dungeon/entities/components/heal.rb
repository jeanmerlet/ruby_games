class Heal < Component
  attr_reader :amount

  def initialize(owner, amount)
    super(owner)
    @amount = amount
  end

  def process(targets)
    results = []
    targets.each do |target|
      if target.combat.hp[0] != target.combat.hp[1]
        target.combat.take_damage(-amount)
        results.push({ message: "The [color=#{@owner.color}]#{@owner.name}[/color] heals you for #{amount}."})
      else
        results.push({ message: "The [color=#{@owner.color}]#{@owner.name}[/color] has no effect."})
      end
    end
    return results
  end
end
