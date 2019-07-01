require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
Dir["#{File.dirname(__FILE__)}/components/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }
require './map.rb'

BLT = Terminal

class Game
  include Config
  include ActionManager
  include FieldOfView
  include ParseInput
  include Render
  include GameStates

  def initialize
    BLT.open
    blt_config
    map_config
    fov_config
    @entities = [create_player]
    @map = GameMap.new(@map_w, @map_h)
    @map.new_level(@side_min, @side_max, @room_tries, @entities, @monster_max)
    @game_state = GameStates::PLAYER_TURN
  end

  def run
    loop do
      fov(@player.x, @player.y, @fov_radius) if @refresh_fov
      render_all(@map, @entities)
      BLT.refresh
      clear_entities(@entities)
      key = BLT.read
      action = parse_input(key)
      action[:quit] ? break : manage_action(action)
    end
    BLT.close
  end

  def create_player
    @player = Entity.new(0, 0, "0x1020", 'amber', 'player')
  end
end

$game = Game.new
$game.run
