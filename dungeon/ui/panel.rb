class PlayerPanel
  attr_reader :x, :y, :width, :height

  def initialize(x, y, width, height, combat)
    @x, @y, @width, @height = x, y, width, height
    @combat = combat
    @max_hp = @combat.max_hp
  end

  def update
  end

  def render
    hp = @combat.hp
    bar_length = ((hp / @max_hp.to_f) * 15).to_i
    BLT.print(@x+5, @y+1, "       ")
    BLT.print(@x+1, @y+1, "HP: #{hp}/#{@max_hp}")
    bar_length.times do |i|
      BLT.print(@x+1+i, @y+2, "[color=light red]=")
    end
    (15-bar_length).times do |i|
      BLT.print(@x+1+bar_length+i, @y+2, "[color=darkest red]=")
    end
  end
end

class TargetPanel
  attr_reader :x, :y, :width, :height, :char, :name, :color

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
    @target = nil
  end

  def new_target(monster)
    if monster
      @char, @name, @color = monster.char, monster.name, monster.color
      #@pre_name = (/[aeiou]/ === @name[0] ? 'an' : 'a')
    end
    @target = monster
  end

  def render
    if @target
      BLT.print(@x+1, @y+1, "Target:")
      BLT.print(@x+1, @y+3, "               ")
      BLT.print(@x+1, @y+3, "[color=#{@color}]#{@char}[/color], #{@name}")
      BLT.print(@x+1, @y+5, "It's          ")
      BLT.print(@x+1, @y+5, "It's [color=red]attacking!")
    else
      BLT.print(@x+1, @y+3, "               ")
      BLT.print(@x+1, @y+5, "               ")
    end
  end
end

class Log
  attr_accessor :new_messages, :old_messages
  attr_reader :x, :y, :width, :height

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
    @new_messages, @old_messages = [], []
    @max_h = @y + @height - 1
  end

  def render
    @new_messages.each_with_index do |message|
      if @y == @max_h
        @height.times {|i| BLT.print(@x, @y - @height + 1 + i, "#{" "*@width}")}
        (@height - 1).times do |i|
          BLT.print(@x, @y - @height + 1 + i, "#{@old_messages[-@height + 1 + i]}")
        end
        BLT.print(@x, @y, "#{message}")
        @old_messages.push(message)
      else
        BLT.print(@x, @y, "#{message}")
        @old_messages.push(message)
        @y += 1
      end
    end
    @new_messages = []
  end
end
