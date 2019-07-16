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
    @map = Map.new(6930)
    @map.new_level(@entities, @player)
    @gui = GUI.new(@player)
    @game_states = [:enemy_turn, :player_turn]
    @active_cmd_domains = [:main, :quit]
    @refresh_fov, @close = true, false
  end

  def run
    until @close
      action = EventHandler.read(@active_cmd_domains)
      results = manage_action(action)
      update(results)
      DisplayManager.render_all(@map, @entities, @player, @gui, @item,
                                @game_states.last)
      BLT.refresh
    end
    BLT.close
  end

  def update(results)
    if !results.empty?
      results.each do |result|
        if result[:message]
          @gui.log.new_messages.push(result[:message])
        elsif result[:picked_up_item]
          @entities.delete(result[:picked_up_item])
        elsif result[:drop_item]
          @entities.push(result[:drop_item])
        elsif result[:death]
          corpse = result[:death]
          if corpse == @player
            @gui.log.new_messages.push(Destroy.player_death_message)
            Destroy.kill_player(corpse)
            @game_states.push(:player_death)
          else
            @gui.log.new_messages.push(Destroy.monster_death_message(corpse))
            Destroy.kill_monster(@map, corpse, @gui.target_info)
          end
        end
      end
    end
    if @refresh_fov
      FieldOfView.do_fov(@map, @player)
      @gui.target_info.update_targettable(@map, @entities, @player)
      @refresh_fov = false
    end
  end

  def create_player
    @entities = []
    fov_r, fov_id = 8, 1
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', fov_r, fov_id)
    hp, defense, power = 30, 0, 3
    @player.inventory = Inventory.new(@player, 26)
    phys, guil, afin, toug = 16, 12, 10, 14
    @player.stats = Stats.new(@player, phys, guil, afin, toug)
    @player.combat = Combat.new(@player, hp, defense, power)
  end
end

game = Game.new
game.run
