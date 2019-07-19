class Bar
  attr_reader :x, :y, :name, :color, :length, :value, :maximum

  def initialize(x, y, length, name, color, values)
    @x, @y, @length = x, y, length
    @name, @color = name, BLT.color_from_name("darker #{color}")
    @bk_color = BLT.color_from_name("darkest #{color}")
    @values = values
  end

  def render
    value, max = *@values
    current_length = ((value.to_f / max) * @length).to_i
    BLT.print(@x+2, @y+1, "#{" "*@length}")
    BLT.print(@x+2, @y+1, "[font=gui]#{@name}: #{value}/#{max}")
    @length.times do |i|
      if i < current_length
        BLT.print(@x+2*(i+1), @y+2, "[color=#{@color}][0xE001]")
      else
        BLT.print(@x+2*(i+1), @y+2, "[color=#{@bk_color}][0xE001]")
      end
    end
  end
end
