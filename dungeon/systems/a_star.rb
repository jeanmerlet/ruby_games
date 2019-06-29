module A_Star

  @@mult = [
            [1, 0, -1, 0],
            [0, -1, 0, 1]
           ]

  def find_path(start_x, start_y, end_x, end_y)
    destination = [end_x, end_y]
    untried = [[start_x, start_y]]
    path = []
    
    while !untried.empty?
      distances = []
      untried.each { |xy| distances << distance(xy, destination) }
      current_xy = untried.index(distances.min.index) #fix
      untried -= current_xy
      path += current_xy
      return path if current_xy == destination
      children = adjacent(current_xy)
      children.each do |child|
        next if path.include?(child)
      end
    end
  end

  def distance(x1y1, x2y2)
  end

  def adjacent(xy)
    x, y = xy[0], xy[1]
    4.times do |i|
      x + @@mult[i]
    end
  end
end
