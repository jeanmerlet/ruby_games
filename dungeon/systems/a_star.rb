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
    unexplored, paths = [init_tile], []
    until unexplored.empty?
      unexplored.sort! { |a, b| a.total_cost <=> b.total_cost } 
      current_tile = unexplored.first
      cx, cy = current_tile.x, current_tile.y
      unexplored.shift
      paths << current_tile
      p paths.size
      if cx == target_x && cy == target_y
        path = []
        until current_tile.parent.nil?
          path << [current_tile.x, current_tile.y]
          current_tile = current_tile.parent
        end
        return path.reverse
      end
      adjacent_tiles(map, current_tile, target_x, target_y).each do |adj|
        adj_x, adj_y = adj.x, adj.y
        next if paths.detect { |tile| tile.x == adj_x && tile.y == adj_y }
        matches = unexplored.select { |tile| tile.x == adj_x && tile.y == adj_y }
        if matches.empty?
          adj.parent = current_tile
          unexplored << adj
        else
          matches.each do |match|
            if match.cost_so_far < current_tile.cost_so_far
              adj.parent = current_tile.parent
              adj.cost_so_far = Math.sqrt(dist(adj_x, adj_y, cx, cy))
              adj.total_cost = adj.dist_to_end + adj.total_cost
              unexplored << adj
            else
              next
            end
          end
        end
      end
    end
    return nil
  end

  def self.adjacent_tiles(map, tile, target_x, target_y)
    adjacent = []
    8.times do |i|
      x, y = tile.x + @@mult[0][i], tile.y + @@mult[1][i]
      if map.tiles[x][y].walkable
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
