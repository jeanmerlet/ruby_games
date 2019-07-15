class Inventory < Component
  attr_accessor :items
  attr_reader :capacity

  def initialize(owner, capacity)
    super(owner)
    @capacity = capacity
    @items = []
  end

  def pick_up(item)
    results = []
    if @items.size < @capacity
      @items << item
      article = (/[aeiou]/ === item.name[0] ? 'an' : 'a')
      item_name = "[color=#{item.color}]#{item.name}[/color]."
      results.push({ message: "You pick up #{article} #{item_name}" })
      results.push({ picked_up_item: item })
    else
      results.push({ message: "There's no room." })
    end
    return results
  end

  def drop_item(item)
    results = []
    remove_item(item)
    item.x, item.y = @owner.x, @owner.y
    results.push({ drop_item: item })
    article = (/[aeiou]/ === item.name[0] ? 'an' : 'a')
    item_name = "[color=#{item.color}]#{item.name}"
    results.push({ message: "You drop #{article} #{item_name}." })
    return results
  end

  def use_item(item, target)
    results = []
    results.push(item.use(target))
    remove_item(item)
    return results
  end

  def remove_item(item)
    @items.delete(item)
  end
end
