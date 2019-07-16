class TargetInfo
  attr_accessor :entities
  attr_reader :x, :y, :width, :char, :name, :color, :target

  def initialize(map, entities, player)
    @x, @y = Config::SCREEN_WIDTH/2 - 17, 10
    @width = 34
    update_targettable(map, entities, player)
    next_target
    BLT.print(2*(@x+1), @y+1, "[font=gui]Current target:")
    BLT.print(2*(@x+1), @y+7, "[font=gui][[Tab]] for next target")
  end

  def next_target
    @target = @targettable.first
    if @target
      update_target
      @targettable.rotate!
    end
  end

  def update_target
    @char, @name, @color = @target.char, @target.name, @target.color
    @article = (/[aeiou]/ === @name[0] ? 'an' : 'a')
    @status = @target.status
  end

  def add_target(target)
    @targettable << target
  end

  def remove_target(target)
    @targettable.delete(target)
  end

  def update_targettable(map, entities, player)
    @targettable = []
    entities.each do |entity|
      if map.fov_tiles[entity.x][entity.y] == player.fov_id
        @targettable.unshift(entity)
      end
    end
    @targettable.delete(player)
  end

  def render
    if @target
      BLT.print(2*(@x+1), @y+3, "#{' '*2*@width}")
      BLT.print(2*(@x+1), @y+3, "[font=reg][color=#{@color}]#{@char}[/color][/font], #{@article} #{@name}")
      BLT.print(2*(@x+1), @y+4, "It's #{' '*2*(@width-4)}")
      BLT.print(2*(@x+1), @y+4, "It's #{@status}")
    else
      BLT.print(2*(@x+1), @y+3, "#{' '*2*@width}")
      BLT.print(2*(@x+1), @y+4, "#{' '*2*@width}")
    end
  end

  def clear
    BLT.clear_area(@x, @y, 34, 7)
  end
end
