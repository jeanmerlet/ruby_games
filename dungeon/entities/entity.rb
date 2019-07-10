class Entity
  attr_accessor :entities, :x, :y, :char, :color, :name, :render_order, :ai,
                :targetted, :status, :blocks

  def initialize(entities, x, y, char, color, name)
    @entities = entities
    @entities << self
    @x, @y = x, y
    @char, @name = char, name
    @color = BLT.color_from_name(color)
  end

  def render
    if @targetted
      BLT.print(2*@x, @y, "[0xE000][+][font=reg][color=#{@color}]#{@char}")
    else
      BLT.print(2*@x, @y, "[font=reg][color=#{@color}]#{@char}")
    end
  end
end
