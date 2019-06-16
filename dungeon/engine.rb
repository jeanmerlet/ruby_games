require './lib/BearLibTerminal/BearLibTerminal.rb'
require './handle_keys.rb'
require './entity.rb'

BLT = Terminal

class Game

  def initialize
    BLT.open
    @screen_w, @screen_h = 80, 50
    @map_w, @map_h = 80, 45
    blt_config
    load_entities
    run
  end

  def run
    loop do
      BLT.refresh

      key = BLT.read
      if key != BLT::TK_ESCAPE && key != BLT::TK_CLOSE
        clear_entities
        handle_input(key)
        render_entities
      else
        break
      end
    end

    BLT.close
  end

  def clear_entities
    @entities.each { |entity| entity.clear }
  end

  def render_entities
    @entities.each { |entity| entity.draw }
  end

  def blt_config
    BLT.set("window: size=#{@screen_w.to_s}x#{@screen_h.to_s}")
    BLT.set("0x1000: ./tiles/arial10x10.png, size=10x10")
  end

  def load_entities
    @player = Entity.new(@screen_w/2, @screen_h/2, "0x1020", 'white')
    npc = Entity.new(@screen_w/2 - 5, @screen_h/2, "0x1020", 'yellow')
    @entities = [@player, npc]
  end
end

game = Game.new
