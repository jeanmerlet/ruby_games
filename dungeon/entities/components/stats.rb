class Stats
  attr_accessor :phys, :guil, :afin, :toug

  def initialize(owner, phys, guil, afin, toug)
    @owner = owner
    @phys, @guil, @afin = phys, guil, afin, toug
  end

  def mod(stat)
    (stat - 10) / 2
  end
end
