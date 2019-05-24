require "./structures.rb"
require "./player.rb"

class Dungeon

  def initialize
    @start = Room.new(3, 3)
    @start.place_start_door
    @start.render
  end
end

class Room

  def initialize(height, width)
    @height = height
    @width = width
    create_walls
    create_floor
  end

  def place_start_door
    side = rand(4)
    case side
    when 0 then wall = @north_wall
    when 1 then wall = @south_wall
    when 2 then wall = @east_wall
    when 3 then wall = @west_wall
    end
    door_spot = rand(3)
    place_doors(wall, door_spot)
  end

  def place_doors(wall, door_spots)
    if wall == @north_wall || wall == @south_wall
      wall[1 + door_spots] = Door.new
    else
      wall[door_spots] = Door.new
    end
  end

  def create_walls
    @north_wall = create_horizontal_wall(@width)
    @south_wall = create_horizontal_wall(@width)
    @west_wall = create_vertical_wall(@height)
    @east_wall = create_vertical_wall(@height)
  end

  def create_horizontal_wall(length)
    wall = []
    (length + 2).times do |i|
      wall << Wall.new
    end
    wall
  end

  def create_vertical_wall(length)
    wall = []
    length.times do |i|
      wall << Wall.new
    end
    wall
  end

  def create_floor
    @floor = []
    @height.times do |i|
      @floor << []
      @width.times do |j|
        @floor[i] << Floor.new
      end
    end
  end

  def render
    @north_wall.each {|wall| print wall.tile}
    print "\n"
    @height.times do |i|
      print @west_wall[i].tile
      @floor[i].each {|floor| print floor.tile}
      print @east_wall[i].tile
      print "\n"
    end
    @south_wall.each {|wall| print wall.tile}
    print "\n"
  end
end


dungeon = Dungeon.new
