class Log
  attr_accessor :new_messages, :old_messages
  attr_reader :x, :y, :width, :height

  def initialize(x, y, width, height)
    @x, @y, @width, @height = x, y, width, height
    @new_messages, @old_messages = [], []
    @max_h = @y + @height
    @y += 1
  end

  def render
    @new_messages.each do |message|
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
