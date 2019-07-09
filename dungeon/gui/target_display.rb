class TargetDisplay
  attr_accessor :entities
  attr_reader :x, :y, :width, :char, :name, :color, :target

  def initialize(x, y, width)
    @x, @y, @width = x, y, width
    @entities = []
    BLT.print(2*(@x+1), @y+1, "Looking at: (TAB)")
  end

  def next_target
    @target.targetted = false if @target
    @target = @entities.first
    if @target
      update_target
      @entities.rotate!
    end
  end

  def update_target
    @target.targetted = true
    @char, @name, @color = @target.char, @target.name, @target.color
    @article = (/[aeiou]/ === @name[0] ? 'an' : 'a')
    @status = @target.status
  end

  def render
    if @target
      BLT.print(2*(@x+1), @y+3, "#{' '*@width}")
      BLT.print(2*(@x+1), @y+3, "[font=reg][color=#{@color}]#{@char}[/color][/font], #{@article} #{@name}")
      BLT.print(2*(@x+1), @y+5, "It's #{' '*(@width-4)}")
      BLT.print(2*(@x+1), @y+5, "It's #{@status}")
    else
      BLT.print(2*(@x+1), @y+3, "#{' '*@width}")
      BLT.print(2*(@x+1), @y+5, "                ")
    end
  end
end
