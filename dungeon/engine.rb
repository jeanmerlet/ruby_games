require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './entities/entity.rb'
require './entities/components/component.rb'
Dir["#{File.dirname(__FILE__)}/entities/**/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/map_objects/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include Config
  include ActionManager
  include FieldOfView
  include EventHandler
  include Render
  include GameStates

  def initialize
    BLT.open
    blt_config
    map_config
    fov_config
    @entities = []
    create_player
    @map = GameMap.new(@map_w, @map_h)
    @map.new_level(@side_min, @side_max, @room_tries, @entities, @monster_max)
    @game_state = GameStates::PLAYER_TURN
    @close = false
  end

  def run
    until @close
      update
      render
      BLT.refresh
      action = handle_input(BLT.read)
      manage_action(action)
    end
    BLT.close
  end

  def update
    clear_entities
    do_fov(@player.x, @player.y, @fov_radius) if @refresh_fov
  end

  def create_player
    @player = Creature.new(@entities, 0, 0, "0x1020", 'player', 'amber')
    hp, defense, power = 30, 0, 3
    @player.combat = Combat.new(@player, hp, defense, power)
  end
end

$game = Game.new
$game.run
