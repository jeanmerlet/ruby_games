class Heal < Component
  attr_reader :amount

  def initialize(owner, amount)
    super(owner)
    @amount = amount
  end

  def process(targets, index)
    results = []
    targets.each do |target|
      if target.combat.hp[0] != target.combat.hp[1]
        target.combat.take_damage(-amount)
        article = (/[aeiou]/ === target.name[0] ? 'An' : 'A')
        target_name = "[color=#{target.color}]#{target.name}[/color]"
        results.push({ message: "#{article} #{target_name} is #{@owner.messages[index]}" })
      else
        results.push({ message: "The [color=#{@owner.color}]#{@owner.name}[/color] have no effect."})
      end
    end
    return results
  end
end
