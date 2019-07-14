class TargetInfo
  attr_accessor :entities
  attr_reader :x, :y, :width, :char, :name, :color, :target

  def initialize(x, y, width)
    @x, @y, @width = x, y, width
    @targettable = []
    BLT.print(2*(@x+1), @y+1, "[font=gui]Looking at:")
    BLT.print(2*(@x+1), @y+6, "[font=gui][[Tab]] to rotate targets")
  end

  def next_target
    @target.targetted = false if @target
    @target = @targettable.first
    if @target
      update_target
      @targettable.rotate!
    end
  end

  def update_target
    @target.targetted = true
    @char, @name, @color = @target.char, @target.name, @target.color
    @article = (/[aeiou]/ === @name[0] ? 'an' : 'a')
    @status = @target.status
  end

  def add_target(target)
    @targettable << target
  end

  def update_targettable(map, entities, player)
    @targettable = []
    entities.each do |entity|
      if map.fov_tiles[entity.x][entity.y] == player.fov_id
        @targettable.unshift(entity)
      end
    end
    @targettable.delete(player)
    @targettable.each { |entity| p entity.name }
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
end
