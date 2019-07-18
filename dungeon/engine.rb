require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './entities/entity.rb'
require './entities/components/component.rb'
ROOT = "#{File.dirname(__FILE__)}"
Dir["#{ROOT}/systems/*.rb"].each { |file| require file }
Dir["#{ROOT}/entities/**/*.rb"].each { |file| require file }
Dir["#{ROOT}/map/*.rb"].each { |file| require file }
Dir["#{ROOT}/gui/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include ActionManager

  def initialize
    BLT.open
    Config.blt_config
    create_player
    @map = Map.new(4575)
    @map.new_level(@entities, @player)
    @gui = GUI.new(@player)
    @viewport = Viewport.new(@map, @entities, @player)
    @game_states = [:enemy_turn, :player_turn]
    @active_cmd_domains = [:main, :movement, :quit]
    @refresh_fov, @close = true, false
  end

  def run
    until @close
      action = EventHandler.read(@active_cmd_domains)
      update(action)
      DisplayManager.render_all(@game_states, @refresh_fov, @map, @viewport,
                                @gui, @entities, @player, @item)
      @refresh_fov = false
    end
    BLT.close
  end

  def create_player
    @entities = []
    fov_r, fov_id = 8, 1
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', fov_r, fov_id)
    hp, defense, power = 30, 0, 3
    @player.inventory = Inventory.new(@player, 26)
    @player.combat = Combat.new(@player, hp, defense, power)
    @player.status = "you!"
  end
end

game = Game.new
game.run
