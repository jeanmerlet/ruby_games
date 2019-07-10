class Inventory
  attr_accessor :items
  attr_reader :capacity

  def initialize(owner, capacity)
    @owner = owner
    @capacity = capacity
    @items = []
  end

  def pick_up(item)
    results = []
    if @items.size < @capacity
      @items << item
      article = (/[aeiou]/ === item.name[0] ? 'an' : 'a')
      item_name = "[color=#{item.color}]#{item.name}"
      results.push({ message: "You pick up #{article} #{item_name}." })
      results.push({ picked_up_item: item })
    else
      results.push({ message: "There's no room." })
    end
    return results
  end
end
