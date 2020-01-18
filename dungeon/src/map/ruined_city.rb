class Map
  attr_accessor :tiles, :fov_tiles
  attr_reader :width, :height

  def initialize(seed = nil)
    @width, @height = 70, 50
    @monster_max, @item_max = 3, 2
    @room_tries = 60
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new } }
    @fov_tiles = Array.new(@width) { Array.new(@height) { 0 } }
    @rooms = []
    @sockets = []
    seed = rand(10000) if seed.nil?
    srand(seed)
    p seed
  end

  def new_level(entities, player)
    place_landing(entities, player)
    #create_level
    #populate_rooms
    bevel_tiles
  end

  def place_landing(entities, player)
    landings = read_prefabs("ruined_city", "landing")
    landing = landings[rand(landings.length)]
    place_prefab(landing, entities)
    x, y = *landing.key("@")
    @tiles[x][y].blocked = false
    @tiles[x][y].passable = true
    player.x, player.y = x, y
    @tiles[player.x][player.y].entities << player
  end

  def read_prefabs(level_name, prefab_type)
    level_name = "./src/map/" + level_name + ".txt"
    start, i = false, -1
    raw_prefabs = []
    File.foreach(level_name, chomp: true) do |line|
      if start
        raw_prefabs[i] << line
        start = false if line =~ /ENDMAP/
      end
      if line =~ /^name: #{prefab_type}\d*$/
        start = true
        raw_prefabs << []
        i += 1
        raw_prefabs[i] << line[6..-1]
      end
    end

    prefabs = []
    raw_prefabs.each do |raw_prefab|
      prefabs << raw_prefab_to_tiles(raw_prefab, 1, 1)
    end
    prefabs
  end

  def raw_prefab_to_tiles(raw_prefab, x, y)
    prefab = {}
    prefab[:name] = raw_prefab.first
    tiles = raw_prefab[raw_prefab.index("MAP")+1..raw_prefab.index("ENDMAP")-1]
    tiles.each.with_index do |tile_line, j|
      tile_line.length.times do |i|
        next if tile_line[i] == " "
        prefab[[x+i, y+j]] = tile_line[i]
      end
    end
    prefab
  end

  def place_prefab(prefab, entities)
    #@rooms << prefab[:name]
    prefab.each_key do |xy|
      x, y = xy[0], xy[1]
      if prefab[xy] == "."
        @tiles[x][y].blocked = false
        @tiles[x][y].passable = true
      end
      if prefab[xy] == "+"
        @tiles[x][y].passable = true
        door = Door.new(entities, x, y, "+", "door", "light_wall")
        door.status = "closed."
        door.desc = "It's a door."
        door.ai = DoorAI.new(door)
        @tiles[x][y].entities << door
        @sockets << [prefab[:name], [x, y]]
      end
    end
  end

  def place_hallway(xy)
  end

  def create_level
    socket = @sockets.first
    type, xy = socket[0], socket[1]
    if usable_socket?(xy)
      if type == 'hallway_end'
        if rand(2) == 0
          prefab = pick_junction(xy)
        else
          prefab = pick_room(type, xy)
        end
        place_prefab(prefab, xy)
        add_sockets(prefab)
      elsif type == 'hallway_side'
        prefab = pick_room(type, xy)
        place_prefab(prefab, xy)
        add_sockets(prefab)
      else
        place_hallway(xy)
      end
    else # convert unusable socket to a wall
      @tiles[xy[0]][xy[1]].passable = false
    end
    @sockets.shift
    create_level if !@sockets.empty?
  end

  def usable_socket?
    true
  end

  def pick_junction
  end

  def pick_room
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
end
