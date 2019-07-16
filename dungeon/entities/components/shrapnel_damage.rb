class ShrapnelDamage < Component
  attr_accessor :amount, :type

  def initialize(owner, amount)
    super(owner)
    @type = :piercing
    @color = "light gray"
    @amount = amount
  end

  def process(targets)
    results = []
    targets.each do |target|
      article = (/[aeiou]/ === target.name[0] ? 'An' : 'A')
      target_name = "[color=#{target.color}]#{target.name}[/color]"
      damage_text = "[color=#{@color}]shredded[/color]"
      results.push({ message: "#{article} #{target_name} is #{damage_text} by the shrapnel!" })
    end
    targets.each { |target| results.push(target.combat.take_damage(@amount)) }
    return results
  end
end
