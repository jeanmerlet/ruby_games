class DungeonStructure
  attr_reader :wall_EW, :wall_NS, :floor

  def initialize
    @wall_top = '_' 
    @wall_bottom = "\u203E".encode('utf-8')
    @wall_NS = '|'
    @floor = '.'
  end
end

class Room < DungeonStructure
attr_reader :contents

  def initialize
    super
    @seed = Random.new
    @size = @seed.rand(5) + 3
    @exits = @seed.rand(4) + 1
    @display = Hash[[*1..@size].repeated_permutation(2).map {|x| [x, '']}]
  end

  def render
    @size.times do |i|
      print "\n"
      @size.times do |j|
        spot = [i+1, j+1]
        print @display[spot]
      end
    end
    print "\n"
  end

  def place_doors
    @exits.times do 
      x = @seed.rand(@size) + 1
      y = @seed.rand(@size) + 1
      spot = [x, y]
      @display[spot] = '@'
    end
  end

  def populate_display
    @display.each do |spot, icon|
      if spot[0] == 1
        @display[spot] = @wall_top
      elsif spot[0] == @size
        @display[spot] = @wall_bottom
      elsif spot[1] == 1 || spot[1] == @size
        @display[spot] = @wall_NS
      else
        @display[spot] = @floor
      end
    end
  end

end

class Door < DungeonStructure
end

room = Room.new
room.populate_display
room.place_doors
room.render
