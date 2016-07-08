class Knight

  def initialize
    @board = [0, 1, 2, 3, 4, 5, 6, 7].repeated_permutation(2).to_a
    @moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
  end

  def knight_moves(start, finish)
    start = MoveNode.new(start)
    move_tree = build_move_tree(start)
    path = find_shortest_path(move_tree, finish)
  end

  def build_move_tree(root, step = 0)
    step += 1
    return if step == 7

    @moves.each do |move|
      next_move_coords = [root.xy[0] + move[0], root.xy[1] + move[1]]

      if @board.include?(next_move_coords)
        new_move_node = MoveNode.new(next_move_coords, root)
        root.children << new_move_node
        build_move_tree(new_move_node, step)
      end
    end

    root
  end

  def find_shortest_path(move_tree, finish)
    queue = [move_tree]

    until move_tree.xy == finish
      move_tree.children.each { |node| queue << node }
      queue.delete_at(0)
      move_tree = queue.first
    end

    path = []

    until move_tree == nil
      path << move_tree.xy
      move_tree = move_tree.parent
    end

    path.reverse
  end

  class MoveNode
    attr_accessor :xy, :parent, :children

    def initialize(coordinates, parent = nil, children = [])
      @xy = coordinates
      @parent = parent
      @children = children
    end
  end
end

knight = Knight.new
puts "Where would you like to place your knight? ([0, 0] to [7, 7])"
start = gets.chomp
start = [start[1].to_i, start[4].to_i]
puts "Where would you like to move your knight? ([0, 0] to [7, 7])"
finish = gets.chomp
finish = [finish[1].to_i, finish[4].to_i]

path = knight.knight_moves(start, finish)
puts "Your moves are as follows:"
path.each { |xy| puts "[#{xy[0]}, #{xy[1]}]" }
