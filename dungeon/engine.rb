require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './entities/entity.rb'
ROOT = "#{File.dirname(__FILE__)}"
Dir["#{ROOT}/systems/*.rb"].each { |file| require file }
Dir["#{ROOT}/entities/**/*.rb"].each { |file| require file }
Dir["#{ROOT}/map/*.rb"].each { |file| require file }
Dir["#{ROOT}/gui/*.rb"].each { |file| require file }

BLT = Terminal

class Game
  include ActionManager
  include RenderManager

  def initialize
    BLT.open
    Config.blt_config
    create_player
    @map = Map.new(7087)
    @map.new_level(@entities, @player)
    gui_init
    create_gui
    #@gui = GUI.new
    @game_states = [:player_turn]
    @active_cmd_domains = [:main, :quit]
    @refresh_fov, @close = true, false
  end

  def run
    until @close
      action = EventHandler.read(@active_cmd_domains)
      results = manage_action(action)
      update(results)
      render_all
      BLT.refresh
    end
    BLT.close
  end

  def update(results)
    if !results.empty?
      results.each do |result|
        if result[:message]
          @log.new_messages.push(result[:message])
        elsif result[:picked_up_item]
          @entities.delete(result[:picked_up_item])
        elsif result[:death]
          corpse = result[:death]
          if corpse == @player
            @log.new_messages.push(Destroy.player_death_message)
            Destroy.kill_player(corpse)
            @game_states.push(:player_death)
          else
            @log.new_messages.push(Destroy.monster_death_message(corpse))
            Destroy.kill_monster(@map, corpse, @target_display)
          end
        end
      end
    end
    if @refresh_fov
      FieldOfView.do_fov(@map, @player)
      @refresh_fov = false

      @target_display.entities = []
      @entities.each do |entity|
        if @map.fov_tiles[entity.x][entity.y] == @player.fov_id
          @target_display.entities.unshift(entity)
        end
      end
      @target_display.entities.delete(@player)
    end
  end

  def create_player
    @entities = []
    fov_r, fov_id = 8, 1
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', fov_r, fov_id)
    hp, defense, power = 30, 0, 3
    @player.combat = Combat.new(@player, hp, defense, power)
    @player.inventory = Inventory.new(@player, 26)
  end

  def create_gui
    @hp_bar = Bar.new(@hp_x, @hp_y, @bar_size, 'HP', 'red', @player.combat.hp)
    @target_display = TargetInfo.new(@targ_x, @targ_y, 2*@side_panel_w)
    @log = Log.new(@log_x, @log_y, @log_w, @log_h)
  end

  def gui_init
    @side_panel_w, @bar_size = 17, 15
    @hp_x, @hp_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 0
    @targ_x, @targ_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 10
    @log_w, @log_h = 78, 5
    @log_x, @log_y = 2, Config::SCREEN_HEIGHT - @log_h - 1
  end
end

game = Game.new
game.run
