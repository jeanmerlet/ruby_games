class TargetInfo
  attr_reader :x, :y, :ret_x, :ret_y, :width, :height, :target

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
    @target = @target_list.first
    if @target
      @ret_x, @ret_y = @target.x, @target.y
      @target_list.rotate!
    end
  end

  def refresh_target_list(map, entities, player)
    @target_list = []
    entities.each do |entity|
      if map.fov_tiles[entity.x][entity.y] == player.fov_id
        @target_list.unshift(entity)
        if @target
          @target_list.sort_by {|target| target.distance_to(player.x, player.y)}
        end
      end
    end
  end

  def move_reticule(move, player)
    dx, dy = *move
    @ret_x += dx
    @ret_y += dy
    @target = player.get_blocking_entity_at(@ret_x, @ret_y)
  end

  def render
    if @target
      article = (/[aeiou]/ === @target.name[0] ? 'an' : 'a')

      BLT.print(@x+2, @y+3, "#{' '*@width}")
      BLT.print(@x+3, @y+3, "[font=reg][color=#{@target.color}]#{@target.char}[/color][/font], #{article} #{@target.name}")
      BLT.print(@x+2, @y+4, "It's #{' '*(@width-4)}")
      BLT.print(@x+2, @y+4, "It's #{@target.status}")
    else
      BLT.print(@x+2, @y+3, "#{' '*@width}")
      BLT.print(@x+2, @y+4, "#{' '*@width}")
    end
  end

  def clear
    BLT.clear_area(@x, @y, @width, @height)
  end
end
