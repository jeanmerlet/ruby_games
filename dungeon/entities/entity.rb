class Entity
  attr_reader :components, :entities

  def initialize(entities)
    @components = []
    @entities = entities
    @entities << self
  end

  def update
    @components.map(&:update)
  end
end
