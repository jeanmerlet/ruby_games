require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
ROOT = "#{File.dirname(__FILE__)}"
Dir["#{ROOT}/systems/*.rb"].each { |file| require file }
Dir["#{ROOT}/entities/**/*.rb"].each { |file| require file }
Dir["#{ROOT}/map/*.rb"].each { |file| require file }
Dir["#{ROOT}/gui/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include ActionManager
  include FieldOfView
  include Render

  def initialize
    BLT.open
    Config.blt_config
    map_init
    gui_init
    create_player
    @map = Map.new(@map_w, @map_h, 6647)
    @map.new_level(@side_min, @side_max, @room_tries, @entities, @monster_max)
    @hp_bar = Bar.new(@hp_x, @hp_y, @bar_size, 'HP', 'red', @player.combat.hp)
    @target_display = TargetDisplay.new(@targ_x, @targ_y, 2*@side_panel_w)
    @log = Log.new(@log_x, @log_y, @log_w, @log_h)
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
    if !results.empty?
      results.each do |result|
        if result[:message]
          @log.new_messages.push(result[:message])
        elsif result[:death]
          corpse = result[:death]
          if corpse == @player
            @log.new_messages.push(Destroy.player_death_message)
            Destroy.kill_player(corpse)
            @state_stack.push(:player_death)
          else
            @log.new_messages.push(Destroy.monster_death_message(corpse))
            Destroy.kill_monster(@map, corpse, @target_display)
          end
        end
      end
    end
    if @refresh_fov
      do_fov(@player.x, @player.y, @fov_radius)
      @refresh_fov = false

      @target_display.entities = []
      @entities.each do |entity|
        if @map.fov_tiles[entity.x][entity.y] == @player.fov_id
          @target_display.entities.unshift(entity) if entity != @player
        end
      end
    end
  end

  def create_player
    @entities = []
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', 1)
    hp, defense, power = 30, 0, 3
    @player.combat = Combat.new(@player, hp, defense, power)
  end

  def map_init
    @map_w, @map_h = 63, 43
    @side_min, @side_max = 3, 5
    @room_tries = 80
    @monster_max = 3
    @fov_radius = 10
    @refresh_fov = true
  end

  def gui_init
    @side_panel_w, @bar_size = 17, 15
    @hp_x, @hp_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 0
    @targ_x, @targ_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 10
    @log_w, @log_h = 78, 5
    @log_x, @log_y = 2, Config::SCREEN_HEIGHT - @log_h - 1
  end
end

$game = Game.new
$game.run
