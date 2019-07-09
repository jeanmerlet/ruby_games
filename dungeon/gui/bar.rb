class Bar
  attr_reader :x, :y, :name, :color, :length, :value, :maximum

  def initialize(x, y, length, name, color, values)
    @x, @y, @length = x, y, length
    @name, @color = name, BLT.color_from_name(color)
    @bk_color = BLT.color_from_name("darkest #{color}")
    @values = values
  end

  def render
    value, max = *@values
    current_length = ((value.to_f / max) * @length).to_i
    BLT.print(@x+1, @y+1, "#{" "*@length}")
    BLT.print(@x+1, @y+1, "#{@name}: #{value}/#{max}")
    current_length.times do |i|
      BLT.print(@x+1+i, @y+2, "[color=#{@color}]=")
    end
    (@length - current_length).times do |i|
      BLT.print(@x+1+current_length+i, @y+2, "[color=#{@bk_color}]=")
    end
  end
end
