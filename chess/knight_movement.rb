class Knight

  def initialize
    @board = [0, 1, 2, 3, 4, 5, 6, 7].repeated_permutation(2).to_a
    @moves = [[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]]
  end

  def knight_moves(start, finish)
    start = MoveNode.new(start)
    move_tree = build_move_tree(start, @moves, finish)
    #path = find_shortest_path(move_tree, finish)
  end

  def build_move_tree(root, moves, finish)

    moves.each do |move|
      next_move_coords = [root.xy[0] + move[0], root.xy[1] + move[1]]

      if @board.include?(next_move_coords)
        new_move_node = MoveNode.new(next_move_coords, root)
        root.children << new_move_node
        #build_move_tree(new_move_node, moves, finish)
      end
    end

    root
  end

  def find_shortest_path(move_tree, finish)
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
knight.knight_moves([1, 1], [7, 7])
