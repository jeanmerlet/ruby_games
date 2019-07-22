require './lib/BearLibTerminal/BearLibTerminal.rb'
require './config/config.rb'
require './src/entities/entity.rb'
require './src/entities/components/component.rb'
ROOT = "#{File.dirname(__FILE__)}/src"
Dir["#{ROOT}/*.rb"].each { |file| require file }
Dir["#{ROOT}/systems/*.rb"].each { |file| require file }
Dir["#{ROOT}/entities/**/*.rb"].each { |file| require file }
Dir["#{ROOT}/map/*.rb"].each { |file| require file }
Dir["#{ROOT}/gui/*.rb"].each { |file| require file }
Dir["#{ROOT}/data/*.rb"].each { |file| require file }

BLT = Terminal

class Game

  def init(restore)
    BLT.open
    Config.blt_config
    new_game if !restore
  end

  def run
    until @close
      action = EventHandler.read(@active_cmd_domains)
      update(action)
      DisplayManager.render(@game_states, @refresh_fov, @map, @viewport, @gui,                               @entities, @player, @item)
      @refresh_fov = false
    end
    BLT.close
  end

  private

  def update(action)
    if action
      game_state = @game_states.last
      results = []
      if game_state == :player_turn
        results.push(take_player_turn(action))
      elsif game_state == :targetting || game_state == :inspecting
        results.push(enter_target_mode(game_state, action))
      elsif game_state == :open_inventory || game_state == :drop_item
        results.push(enter_inventory_mode(game_state, action))
      elsif game_state == :inspect_details
        inspect_details(action)
      end
      results.flatten!
      process_results(results)

      game_state = @game_states.last
      results = []
      if game_state == :enemy_turn
        results.push(take_enemy_turn)
      elsif game_state == :player_death
        @close = true if BLT.read
      end
      results.flatten!
      process_results(results)
    end
  end

  def process_results(results)
    if !results.empty?
      results.each do |result|
        if result[:message]
          @gui.log.new_messages.push(result[:message])
        elsif result[:picked_up_item]
          item = result[:picked_up_item]
          @entities.delete(item)
          @map.tiles[item.x][item.y].remove_entity(item)
        elsif result[:drop_item]
          item = result[:drop_item]
          @entities.push(item)
          @map.tiles[item.x][item.y].add_entity(item)
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
  end

  def take_player_turn(action)
    results = []
    if action[:move]
      results.push(move_player(action[:move]))
    elsif action[:inspecting]
      @game_states << :inspecting
      @active_cmd_domains.delete(:main)
      @active_cmd_domains << :targetting
      @gui.target_info = TargetInfo.new(@map, @entities, @player, "Looking at")
    elsif action[:pick_up]
      results.push(pick_up_item)
    elsif action[:inventory] || action[:drop]
      @game_states << (action[:inventory] ? :open_inventory : :drop_item)
      @active_cmd_domains.delete(:main)
      @active_cmd_domains.delete(:movement)
      @active_cmd_domains << :menu
    elsif action[:save_and_quit]
      save_and_quit
    elsif action[:abandon]
      abandon
    end
    return results
  end

  def enter_target_mode(game_state, action)
    results = []
    if action[:next_target]
      @gui.target_info.next_target
    elsif action[:move]
      @gui.target_info.move_reticule(action[:move], @player)
    elsif action[:select_target]
      if game_state == :targetting
        x, y = @gui.target_info.ret_x, @gui.target_info.ret_y
        results.push(@player.inventory.use_item(@item, x, y))
        2.times { @game_states.pop }
        action[:quit] = true
      elsif game_state == :inspecting
        #what happens when you select a target you are inspecting
        if @gui.target_info.target
          @game_states << :inspect_details
          @active_cmd_domains = [:quit]
        end
      end
    end
    if action[:quit]
      @viewport.refresh
      @gui.target_info.clear
      @gui.target_info = nil
      @item = nil
      # don't return to inventory if cancelling item selection confirmation
      @game_states.pop if @game_states.last == :targetting
      @game_states.pop
      @active_cmd_domains.delete(:targetting)
      @active_cmd_domains << :main
    end
    return results
  end

  def inspect_details(action)
    if action[:quit]
      @game_states.pop
      @active_cmd_domains << :targetting
      @active_cmd_domains << :movement
    end
  end

  def enter_inventory_mode(game_state, action)
    results = []
    if action[:option_index]
      results.push(select_inv_item(action[:option_index], game_state))
    end
    if action[:quit]
      @game_states.pop
      @active_cmd_domains.delete(:menu)
      @active_cmd_domains << :main
      @active_cmd_domains << :movement
    end
    return results
  end

  def select_inv_item(index, game_state)
    results = []
    item = @player.inventory.items[index]
    if item
      if game_state == :open_inventory
        if item.is_a?(Consumable)
          @item = item
          @gui.target_info = TargetInfo.new(@map, @entities, @player, "Target",
                                            @item)
          @game_states << :targetting
          @active_cmd_domains.delete(:menu)
          @active_cmd_domains << :targetting
          @active_cmd_domains << :movement
        else
          #equipment
        end
      elsif game_state == :drop_item
        results.push(@player.inventory.drop_item(item))
        @game_states.pop
        @active_cmd_domains.delete(:menu)
        @active_cmd_domains << :main
        @active_cmd_domains << :movement
      end
    end
    return results
  end

  def drop_item(action, index)
    results = []
    item = @player.inventory.items[index]
    if item
      @game_states.pop
    end
    return results
  end

  def pick_up_item
    results = []
    x, y = @player.x, @player.y
    item = @player.get_items_at(x, y).first
    if item
      results.push(@player.inventory.pick_up(item))
      @game_states.pop
    else
      results.push({ message: "There's nothing there." })
    end
    return results
  end

  def move_player(move)
    dx, dy = *move
    end_x, end_y = @player.x + dx, @player.y + dy
    results = []
    if !@map.tiles[end_x][end_y].blocked
      target = @player.get_blocking_entity_at(end_x, end_y)
      if target.nil? || target == @player
        @player.move(@map, dx, dy)
      else
        results.push(@player.combat.attack(target))
      end
      @refresh_fov = true
      @game_states.pop
    end
    return results
  end

  def take_enemy_turn
    results = []
    @entities.each do |entity|
      if entity.ai
        results.push(entity.ai.take_turn(@map, @player, @gui))
      end
    end
    @game_states << :player_turn
    return results
  end

  def new_game
    @entities = []
    create_player
    @map = Map.new(3712)
    @map.new_level(@entities, @player)
    @gui = GUI.new(@player)
    @viewport = Viewport.new(@map, @entities, @player)
    @game_states = [:enemy_turn, :player_turn]
    @active_cmd_domains = [:main, :movement, :quit]
    @refresh_fov, @close = true, false
  end

  def create_player
    fov_r, fov_id = 10, 1
    @player = Actor.new(@entities, 0, 0, "@", 'player', 'amber', fov_r, fov_id)
    hp, defense, power = 30, 0, 3
    @player.inventory = Inventory.new(@player, 26)
    @player.combat = Combat.new(@player, hp, defense, power)
    @player.status = "you!"
    @player.desc = "One of those pesky thrill-seeking adventurers, here seeking thrills."
  end

  def save_and_quit
    Serialize.save_game(self)
    @close = true
  end

  def abandon
    File.delete("./src/data/game.sav") if FileTest.exists?("./src/data/game.sav")
    @close = true
  end
end

if FileTest.exists?("./src/data/game.sav")
  game = Serialize.restore("./src/data/game.sav")
  restore = true
else
  game = Game.new
  restore = false
end
game.init(restore)
game.run
