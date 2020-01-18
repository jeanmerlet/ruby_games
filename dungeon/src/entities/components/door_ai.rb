class DoorAI < Component

  def initialize(owner)
    super(owner)
  end

  def take_turn(map, player)
    results = []
    if @owner.closed && any_adjacent_actors?
      map.tiles[@owner.x][@owner.y].blocked = false
      @owner.closed = false
      @owner.blocks = false
      @owner.char = ""
      @owner.status = "open."
    elsif !@owner.closed && !any_adjacent_actors?
      map.tiles[@owner.x][@owner.y].blocked = true
      @owner.closed = true
      @owner.blocks = true
      @owner.char = "+"
      @owner.status = "closed."
    end
    return results
  end

  def any_adjacent_actors?
    x, y = @owner.x , @owner.y
    3.times do |i|
      3.times do |j|
        actor = @owner.get_blocking_entity_at(x - 1 + i, y - 1 + j)
        return true if actor && actor.is_a?(Actor)
      end
    end
    return false
  end
end
