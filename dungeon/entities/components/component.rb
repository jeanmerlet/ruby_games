class Component
  attr_reader :owner

  def initialize(owner)
    @owner = owner
    @owner.components << self
  end

  def update
  end

  def x
    @owner.x
  end

  def y
    @owner.y
  end
end
