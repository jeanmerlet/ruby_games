require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './entities/entity.rb'
require './entities/components/component.rb'
require './map_objects/generate_level.rb'
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/entities/**/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/map_objects/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include Config
  include ActionManager
  include FieldOfView
  include EventHandler
  include Render

  def initialize
    BLT.open
    blt_config
    map_config
    fov_config
    @entities = []
    create_player
    #24 for pathing
    @map = Map.new(@map_w, @map_h, 24)
    @map.new_level(@side_min, @side_max, @room_tries, @entities, @monster_max)
    @state_stack = [:player_turn]
    @close = false
  end

  def run
    until @close
      BLT.has_input? ? action = handle_input(BLT.read) : action = nil
      results = manage_action(action)
      update(results)
      render_all
      BLT.refresh
    end
    BLT.close
  end

  def update(results)
    clear_entities
    do_fov(@player.x, @player.y, @fov_radius) if @refresh_fov
    if !results.empty?
      results.each do |result|
        if result[:message]
          render_message(result[:message])
        elsif result[:death]
          corpse = result[:death]
          if corpse == @player
            render_message(Destroy.player_death_message)
            Destroy.kill_player(corpse)
            @state_stack.push(:player_death)
          else
            render_message(Destroy.monster_death_message(corpse))
            Destroy.kill_monster(corpse)
          end
        end
      end
    end
  end

  def create_player
    @player = Actor.new(@entities, 0, 0, "0x1020", 'player', 'amber', 1)
    hp, defense, power = 30, 0, 3
    @player.combat = Combat.new(@player, hp, defense, power)
  end
end

$game = Game.new
$game.run
