class Entity
  attr_reader :components, :object_pool

  def initialize(entity_pool)
    @components = []
    @object_pool = entity_pool
    @object_pool << self
  end

  def update
    @components.map(&:update)
  end
end
