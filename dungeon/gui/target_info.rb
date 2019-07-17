class TargetInfo
  #attr_accessor :target_list
  attr_reader :x, :y, :tar_x, :tar_y, :width, :height, :char, :name, :color, :target

  def initialize(map, entities, player, item = nil)
    @x, @y = Config::SCREEN_WIDTH - Config::SIDE_PANEL_WIDTH, 10
    @width, @height = Config::SIDE_PANEL_WIDTH, 20
    @item = item
    refresh_target_list(map, entities, player)
    next_target
    BLT.print(@x+2, @y+1, "[font=gui]Current target:")
    BLT.print(@x+2, @y+7, "[font=gui][[Tab]] or [[Numpad]] to change targets")
  end

  def next_target
    @current_target = @target_list.first
    if @current_target
      update_target_info
      @target_list.rotate!
    end
  end

  def update_target_info
    @char, @name, @color = @current_target.char, @current_target.name, @current_target.color
    @tar_x, @tar_y = @current_target.x, @current_target.y
    @article = (/[aeiou]/ === @name[0] ? 'an' : 'a')
    @status = @current_target.status
  end

  def add_target(target)
    @target_list << target
  end

  def remove_target(target)
    @target_list.delete(target)
  end

  def refresh_target_list(map, entities, player)
    @target_list = []
    entities.each do |entity|
      if map.fov_tiles[entity.x][entity.y] == player.fov_id
        @target_list.unshift(entity)
        if @current_target
          @target_list.sort_by {|target| target.distance_to(player.x, player.y)}
        end
      end
    end
  end

  def move_reticule(move)
    dx, dy = move
    @tar_x += dx
    @tar_y += dy
  end

  def render
    if @current_target
      BLT.print(@x+2, @y+3, "#{' '*@width}")
      BLT.print(@x+3, @y+3, "[font=reg][color=#{@color}]#{@char}[/color][/font], #{@article} #{@name}")
      BLT.print(@x+2, @y+4, "It's #{' '*(@width-4)}")
      BLT.print(@x+2, @y+4, "It's #{@status}")
    else
      BLT.print(@x+2, @y+3, "#{' '*@width}")
      BLT.print(@x+2, @y+4, "#{' '*@width}")
    end
  end

  def clear
    BLT.clear_area(@x, @y, @width, @height)
  end
end
