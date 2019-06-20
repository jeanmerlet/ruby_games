module HandleKeys

  def handle_input(key)
    #movement
    dx, dy = 0, 0
    case key
    when Terminal::TK_UP, Terminal::TK_K
      dy = -1
    when Terminal::TK_DOWN, Terminal::TK_J
      dy = 1
    when Terminal::TK_LEFT, Terminal::TK_H
      dx = -1
    when Terminal::TK_RIGHT, Terminal::TK_L
      dx = 1
    end

    move_player(dx, dy)
  end

  def move_player(dx, dy)
    if !@map.blocked?(@player.x + dx, @player.y + dy)
      @player.x += dx
      @player.y += dy
    end
  end
end
