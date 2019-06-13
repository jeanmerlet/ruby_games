require './lib/BearLibTerminal/BearLibTerminal.rb'

@screen_height, @screen_width = '80', '50'
@player_x, @player_y = @screen_width.to_i/2, @screen_height.to_i/2

Terminal.open
Terminal.set("window: title='meow', size=#{@screen_height}x#{@screen_width}")
#Terminal.set("font: ./tiles/arial10x10.png, size=10x10, format=truetype")
@close = false

while !@close
  Terminal.clear
  Terminal.print(@player_y, @player_x, "@")
  Terminal.refresh
  @input = Terminal.read
  @close = true if @input == Terminal::TK_CLOSE
end

Terminal.close
