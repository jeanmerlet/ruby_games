class Map
  attr_accessor :tiles, :fov_tiles
  attr_reader :width, :height

  def initialize(level_type = "ruined_city", seed = nil)
    @width, @height = 101, 51
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new } }
    @fov_tiles = Array.new(@width) { Array.new(@height) { 0 } }
    @sockets, @socket_index = [], 0
    @level_type = level_type
    seed = rand(10000) if seed.nil?
    srand(seed)
    p seed
  end

  def new_level(level_type, entities, player)
    raw_blocks = read_blocks(level_type)
    @blocks = parse_raw_blocks(raw_blocks)
    generate_block_order
    create_level(entities, player)
    #populate_rooms
    bevel_tiles
  end

  def generate_block_order
    @block_order, names = [], []
    @blocks.each do |block|
      
    end
  end

  def place_landing(entities, player)
    raw_landings = read_blocks("ruined_city", "landing")
    landing = raw_landings[rand(raw_landings.length)]
    landing = parse_raw_block(raw_landing, 0, 4, [1, 0])
    place_block(landing, entities)
    place_player(player, landing.key("@"))
  end

  def create_level(entities)
    x, y = *@sockets.first
    raw_block = raw_blocks[rand(raw_blocks.length)]
    block = parse_raw_block(raw_block, x, y)
    place_block(x, y, block, entities)
    @socket_index += 1
    create_level(entities) if @socket_index != @sockets.size
  end

  def read_blocks(level_name)
    level_name = "./src/map/" + level_name + ".txt"
    start, i = false, -1
    raw_blocks = []
    File.foreach(level_name, chomp: true) do |line|
      if start
        raw_blocks[i] << line
        start = false if line =~ /ENDMAP/
      end
      if line =~ /^name:/
        start = true
        raw_blocks << []
        i += 1
      end
    end
    raw_blocks
  end

  def parse_raw_block(raw_block, x, y, dir)
    block = {}
    block[:name] = raw_block[0][6..-1]
    block[:rotations] = raw_block[2][-1]
    block[:tiles] = []
    tiles = raw_block[raw_block.index("MAP")+1..raw_block.index("ENDMAP")-1]
    tiles.each.with_index do |tile_line, j|
      tile_line.length.times do |i|
        block[[x+i, y+j]] = tile_line[i]
      end
    end
    block
  end

  def rotate_block(block, x, y, dir)
    blocks = [block]
    new_block = {}
    block[:rotations].times do |i|
      9.times do |a|
        9.times do |b|
          #new_block[[a, b]] = 
        end
      end
    end
  end

  def place_block(block, entities)
    block.each_key do |xy|
      x, y = xy[0], xy[1]
      if block[xy] == "."
        @tiles[x][y].blocked = false
        @tiles[x][y].passable = true
      elsif block[xy] == "+"
        @tiles[x][y].passable = true
        door = Door.new(entities, x, y, "+", "door", "light_wall")
        door.status = "closed."
        door.desc = "It's a door."
        door.ai = DoorAI.new(door)
        @tiles[x][y].entities << door
        @door_count += 1
      elsif block[xy] == "*"
        add_socket(block, x, y)
      end
    end
  end

  def add_socket(block, x, y)
    if block[[x+1, y]].nil?
      dir = [1, 0]
    elsif block[[x, y+1]].nil?
      dir = [0, 1]
    elsif block[[x-1, y]].nil?
      dir = [-1, 0]
    elsif block[[x, y-1]].nil?
      dir = [0, -1]
    end
    if socket_usable?(x, y, dir) && !@tiles[x][y].passable
      @tiles[x][y].blocked = false
      @tiles[x][y].passable = true
      a, b = *get_xy_offset(*dir)
      x += a
      y += b
      @sockets << [x, y]
    end
  end

  def place_player(player, xy)
    x, y = *xy
    @tiles[x][y].blocked = false
    @tiles[x][y].passable = true
    player.x, player.y = x, y
    @tiles[player.x][player.y].entities << player
  end

  def bevel_tiles
    @tiles.each_with_index do |tile_line, x|
      next if x == 0
      break if x == @width - 1
      tile_line.each_with_index do |tile, y|
        next if y == 0 || !tile.blocked
        break if y == @height - 1
        neighbors = neighbor_block_values(x, y)
        block_count = neighbors.count(true)
        if block_count < 3
          n, s, e, w = *neighbors
          if block_count == 2
            if !n && !w
              tile.bevel_nw = true
            elsif !n && !e
              tile.bevel_ne = true
            elsif !s && !e
              tile.bevel_se = true
            elsif !s && !w
              tile.bevel_sw = true
            end
          elsif block_count == 1
            if n
              tile.bevel_sw, tile.bevel_se = true, true
            elsif s
              tile.bevel_nw, tile.bevel_ne = true, true
            elsif e
              tile.bevel_nw, tile.bevel_sw = true, true
            else
              tile.bevel_ne, tile.bevel_se = true, true
            end
          else
            tile.bevel_nw = true
            tile.bevel_ne = true
            tile.bevel_sw = true
            tile.bevel_se = true
          end
        end
      end
    end
  end

  def neighbor_block_values(x, y)
    [@tiles[x][y-1].blocked, @tiles[x][y+1].blocked,
     @tiles[x+1][y].blocked, @tiles[x-1][y].blocked]
  end

  def out_of_bounds?(x, y)
    x < 0 || x >= @width || y < 0 || y >= @height
  end

  def socket_usable?(x, y, dir)
    x += dir[0]
    y += dir[1]
    !out_of_bounds?(x, y)
  end

  def get_xy_offset(x_dir, y_dir)
    b = -5 if x_dir != 0
    a = -10 if x_dir == -1
    a = -5 if y_dir != 0
    b = -10 if y_dir == -1
    [a, b]
  end
end
