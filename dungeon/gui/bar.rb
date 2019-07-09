class Bar
  attr_reader :x, :y, :name, :color, :length, :value, :maximum

  def initialize(x, y, length, name, color, values)
    @x, @y, @length = x, y, length
    @name, @color = name, BLT.color_from_name("dark #{color}")
    @bk_color = BLT.color_from_name("darkest #{color}")
    @values = values
  end

  def render
    value, max = *@values
    current_length = ((value.to_f / max) * @length).to_i
    BLT.print(2*(@x+1), @y+1, "#{" "*@length}")
    BLT.print(2*(@x+1), @y+1, "#{@name}: #{value}/#{max}")
    @length.times do |i|
      if i < current_length
        BLT.print(2*(@x+i+1), @y+3, "[font=reg][bkcolor=#{@color}] ")
      else
        BLT.print(2*(@x+i+1), @y+3, "[font=reg][bkcolor=#{@bk_color}] ")
      end
    end
  end
end
