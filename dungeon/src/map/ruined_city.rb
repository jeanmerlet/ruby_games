class Map
  attr_accessor :tiles, :fov_tiles
  attr_reader :width, :height

  def initialize(seed = nil)
    @width, @height = 70, 50
    @monster_max, @item_max = 3, 2
    @room_tries = 60
    @tiles = Array.new(@width) { Array.new(@height) { Tile.new } }
    @fov_tiles = Array.new(@width) { Array.new(@height) { 0 } }
    @sockets = []
    seed = rand(10000) if seed.nil?
    srand(seed)
    p seed
  end

  def new_level(player)
    place_landing(player)
    create_level
    populate_rooms
    place_player
    bevel_tiles
  end

  def place_landing(player)
    landing = read_prefab("ruined_city", "landing", [1, 1])
    place_prefab(landing, [1, 1])
    add_sockets(landing)
    player.x, player.y = *landing['@']
  end

  # read_prefab creates a prefab hash from .txt file with tile type for keys
  # and coordinates for values e.g. '#' => [[1, 1], [1, 2], ...]

  def read_prefab(level_name, prefab_type, xy)
  end

  def place_prefab(prefab, xy)
    prefab['.'].each do |xy|
      @tiles[xy[0]][xy[1]].blocked = false
      @tiles[xy[0]][xy[1]].walkable = true
    end
    prefab['+'].each do |xy|
      @tiles[xy[0]][xy[1]].walkable = true
    end
  end

  def place_hallway(xy)
  end

  # sockets are array pairs consisting of name then xy-coords for the socket

  def add_sockets(prefab)
    prefab['+'].each { |xy| @sockets << [prefab[:name], xy] }
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
      @tiles[xy[0]][xy[1]].walkable = false
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
end
