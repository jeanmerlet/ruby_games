module A_Star

  def find_path(start_x, start_y, end_x, end_y)
    destination = [end_x, end_y]
    untried = [[start_x, start_y]]
    path = []
    
    while !untried.empty?
      distances = []
      untried.each do |xy|
        distances << distance(xy, destination)
        current_xy = untried.index(distances.min.index) #fix
      end
      untried -= current_xy
      path += current_xy
      return path if current_xy == destination
      children = adjacent(current_xy)
      children.each do |child|
        next if path.include?(child)
        child.g
      end
    end
  end

  def distance(x1y1, x2y2)
  end

  def adjacent(xy)
  end
end
