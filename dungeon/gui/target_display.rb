class TargetDisplay
  attr_accessor :targets
  attr_reader :x, :y, :char, :name, :color, :target

  def initialize(x, y)
    @x, @y = x, y
    @targets = []
    BLT.print(@x+1, @y+1, "Target: (TAB)")
  end

  def next_target
    @target = @targets.first
    update_target if @target
    @targets.rotate!
  end

  def update_target
    @char, @name, @color = @target.char, @target.name, @target.color
    @status = @target.status
  end

  def render
    if @target
      BLT.print(@x+1, @y+3, "                ")
      BLT.print(@x+1, @y+3, "[color=#{@color}]#{@char}[/color], #{@name}")
      BLT.print(@x+1, @y+5, "It's            ")
      BLT.print(@x+1, @y+5, "It's #{@status}")
    else
      BLT.print(@x+1, @y+3, "                ")
      BLT.print(@x+1, @y+5, "                ")
    end
  end
end
