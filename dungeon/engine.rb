require './lib/BearLibTerminal/BearLibTerminal.rb'
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/map_objects/*.rb"].each { |file| require file }
require './entity.rb'

BLT = Terminal

class Game

  def initialize
    @screen_w, @screen_h = 80, 50
    @map_w, @map_h = 80, 45
    #@map = GameMap.new(@map_w, @map_h)
    BLT.open
    blt_config
    @entities = load_entities
    run
  end

  def run
    #render_map(@map)
    loop do
      BLT.refresh
      key = BLT.read
      if key != BLT::TK_ESCAPE && key != BLT::TK_CLOSE
        clear_entities(@entities)
        handle_input(key)
        render_entities(@entities)
      else
        break
      end
    end
    BLT.close
  end

  def blt_config
    BLT.set("window: size=#{@screen_w.to_s}x#{@screen_h.to_s}")
    BLT.set("0x1000: ./tilesets/arial10x10.png, size=10x10")
  end

  def load_entities
    @player = Entity.new(@screen_w/2, @screen_h/2, "0x1020", 'white')
    npc = Entity.new(@screen_w/2 - 5, @screen_h/2, "0x1020", 'yellow')
    [@player, npc]
  end
end

Game.new
