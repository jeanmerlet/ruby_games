class Structure
  attr_reader :tile

  def render
    print @tile
  end
end

class Floor < Structure
  attr_accessor :contents

  def initialize
    @tile = "."
    @contents = []
  end
end

class StairDown < Structure

  def initialize
    @tile = ">"
  end
end

class StairUp < Structure

  def initialize
    @tile = "<"
  end
end

class Door < Structure

  def initialize
    @tile = "+"
  end
end

class Wall < Structure

  def initialize
    @tile = "#"
  end
end
