require './lib/BearLibTerminal/BearLibTerminal.rb'
Dir["#{File.dirname(__FILE__)}/components/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/map_objects/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include Render
  include HandleKeys
  include FieldOfView

  def initialize
    @screen_w, @screen_h = 80, 50
    BLT.open
    blt_config
    @entities = create_entities
    map_config
    @map = GameMap.new(@map_w, @map_h)
    @map.generate_level(@min_length, @max_length, @max_rooms, @player)
    #@fov = Circle.new(@player.x, @player.y, @fov_radius)
  end

  def run
    render_all(@map, @entities)
    loop do
      BLT.refresh
      key = BLT.read
      if key != BLT::TK_ESCAPE && key != BLT::TK_CLOSE
        clear_entities(@entities)
        handle_input(key)
        render_all(@map, @entities)
      else
        break
      end
    end
    BLT.close
  end

  def blt_config
    BLT.set("window: size=#{@screen_w.to_s}x#{@screen_h.to_s}")
    BLT.set("0x1000: ./tilesets/arial10x10.png, size=10x10")
    BLT.set("palette.dark_wall = 0,0,100")
    BLT.set("palette.dark_ground = 50,50,150")
    BLT.set("palette.light_wall = 130,110,50")
    BLT.set("palette.light_ground = 200,180,50")
  end

  def map_config
    @map_w, @map_h = 80, 45
    @min_length, @max_length = 3, 5
    @max_rooms = 70
    @fov_radius = 10
  end

  def create_entities
    @player = Entity.new(@screen_w/2, @screen_h/2, "0x1020", 'amber')
    [@player]
  end
end

$game = Game.new
$game.run
