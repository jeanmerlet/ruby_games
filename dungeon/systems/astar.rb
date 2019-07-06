module A_Star

  class PathTile
    attr_accessor :parent, :cost_so_far, :total_cost
    attr_reader :x, :y, :dist_to_end

    def initialize(x, y, dist_to_end, cost_so_far, parent = nil)
      @x, @y, = x, y
      @dist_to_end = dist_to_end
      @cost_so_far = cost_so_far
      @total_cost = @dist_to_end + @cost_so_far
      @parent = parent
    end
  end

  @@mult = [
            [1, 1, 1, -1, -1, -1, 0, 0],
            [1, 0, -1, 1, 0, -1, 1, -1],
            [1.41, 1, 1.41, 1.41, 1, 1.41, 1, 1]
           ]

  def self.find_path(map, start_x, start_y, target_x, target_y)
    init_distance = dist(start_x, start_y, target_x, target_y)
    init_tile = PathTile.new(start_x, start_y, init_distance, 0)
    unexplored, paths = [init_tile], {}
    until unexplored.empty?
      unexplored.sort! { |a, b| a.total_cost <=> b.total_cost } 
      current_tile = unexplored.first
      cx, cy = current_tile.x, current_tile.y
      unexplored.shift
      paths[[cx, cy]] = true
      if cx == target_x && cy == target_y
        path = []
        until current_tile.parent.nil?
          path << [current_tile.x, current_tile.y]
          current_tile = current_tile.parent
        end
        return path.reverse
      end
      adjacent_tiles(map, current_tile, target_x, target_y, paths).each do |adj|
        adj_x, adj_y = adj.x, adj.y
        match = unexplored.detect { |tile| tile.x == adj_x && tile.y == adj_y }
        if !match
          adj.parent = current_tile
          unexplored << adj
        elsif match.cost_so_far < current_tile.cost_so_far
          match.parent = current_tile.parent
          match.cost_so_far = Math.sqrt(dist(adj_x, adj_y, cx, cy))
          match.total_cost = match.dist_to_end + adj.total_cost
        end
      end
    end
    return nil
  end

  def self.adjacent_tiles(map, tile, target_x, target_y, paths)
    adjacent = []
    8.times do |i|
      x, y = tile.x + @@mult[0][i], tile.y + @@mult[1][i]
      if (map.tiles[x][y].walkable && !paths[[x, y]]) ||
         (x == target_x && y == target_y) # ignore if it is not walkable
        adjacent << PathTile.new(x, y, dist(x, y, target_x, target_y),
                    tile.cost_so_far + @@mult[2][i])
      end
    end
    return adjacent
  end

  def self.dist(x1, y1, x2, y2)
    return ((x1 - x2)**2 + (y1 - y2)**2)
  end
end
