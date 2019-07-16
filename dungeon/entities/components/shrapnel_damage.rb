class Damage < Component
  attr_accessor :amount, :type

  def initialize(owner, type, amount)
    super(owner)
    @type = type
    @amount = amount
  end

  def process(targets, index)
    results = []
    targets.each do |target|
      article = (/[aeiou]/ === target.name[0] ? 'An' : 'A')
      target_name = "[color=#{target.color}]#{target.name}[/color]"
      results.push({ message: "#{article} #{target_name} is #{@owner.messages[index]}" })
    end
    targets.each { |target| results.push(target.combat.take_damage(@amount)) }
    return results
  end
end
