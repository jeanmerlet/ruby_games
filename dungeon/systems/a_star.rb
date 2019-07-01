module A_Star

  @@mult = [
            [1, 0, -1, 0],
            [0, -1, 0, 1]
           ]

  def find_path(start_x, start_y, end_x, end_y)
    h = distance(start_x, start_y, end_x, end_y)
    untried, path = [PathingTile.new(start_x, start_y, 0, h)], []
    while !untried.empty?
      distances = []
      untried.each { |node| distances << distance(node.x, node.y, end_x, end_y) }
      current_node = untried[distances.index(distances.min)]
      untried -= current_node
      path += current_node
      if current_node.x == end_x && current_node.y == end_y
        return path
      end
      children = adjacent(current_node)
      children.each do |child|
        next if path.include?(child)
      end
    end
    nil
  end

  def distance(x1, y1, x2, y2)
    (x2-x1)**2 + (y2-y1)**2
  end

  def adjacent(node)
    4.times do |i|
      x, y = node.x, node.y
      x += @@mult[0][i]
      y += @@mult[1][i]
      node = Node.new(x, y)
    end
  end
end
