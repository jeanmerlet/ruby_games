require './lib/BearLibTerminal/BearLibTerminal.rb'
require './handle_keys.rb'

@screen_width, @screen_height = '80', '50'
@player_x, @player_y = @screen_width.to_i/2, @screen_height.to_i/2
@close = false

Terminal.open
Terminal.set("window: title='meow', size=#{@screen_width}x#{@screen_height}")

def parse_action(action)
  move = action[:move]
  quit = action[:quit]

  if move
    dx, dy = move[0], move[1]
    @player_x += dx
    @player_y += dy
  end

  @close = true if quit
end

while !@close
  Terminal.clear
  Terminal.print(@player_x, @player_y, '@')
  Terminal.refresh

  input = Terminal.read
  action = handle_keys(input)
  parse_action(action)
end

Terminal.close

