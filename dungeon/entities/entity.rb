class Entity
  attr_reader :components, :object_pool

  def initialize(entities)
    @components = []
    @entities = entities
    @entities << self
  end

  def update
    @components.map(&:update)
  end
end
