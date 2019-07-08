require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './entities/entity.rb'
require './entities/components/component.rb'
require './map_objects/generate_level.rb'
require './ui/panel.rb'
Dir["#{File.dirname(__FILE__)}/systems/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/entities/**/*.rb"].each { |file| require file }
Dir["#{File.dirname(__FILE__)}/map_objects/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include Config
  include ActionManager
  include FieldOfView
  include Render

  def initialize
    BLT.open
    blt_config
    map_config
    fov_config
    ui_config
    @entities = []
    create_player
    @player_panel = PlayerPanel.new(@char_panel_x, @char_panel_y, @panel_w, @panel_h,                                    @player.combat)
    @target_panel = TargetPanel.new(@char_panel_x, @char_panel_y + 10, @panel_w, @panel_h)
    @targets = []
    @map = Map.new(@map_w, @map_h)
    @map.new_level(@side_min, @side_max, @room_tries, @entities, @monster_max)
    @state_stack = [:player_turn]
    @close = false
  end

  def run
    until @close
      action = EventHandler.read
      results = manage_action(action)
      update(results)
      render_all
      BLT.refresh
    end
    BLT.close
  end

  def update(results)
    clear_entities
    if @refresh_fov
      do_fov(@player.x, @player.y, @fov_radius)
      @targets = []
      @entities.each do |entity|
        if @map.fov_tiles[entity.x][entity.y] == @player.fov_id
          @targets << entity if entity != @player
        end
      end
    end
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
            Destroy.kill_monster(@map, corpse)
          end
        end
      end
    end
  end

  def create_player
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', 1)
    hp, defense, power = 30, 0, 3
    @player.combat = Combat.new(@player, hp, defense, power)
  end
end

$game = Game.new
$game.run
