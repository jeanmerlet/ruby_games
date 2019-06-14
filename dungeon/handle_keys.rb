def handle_keys(key)
  #movement
  if key == Terminal::TK_UP || key == Terminal::TK_K
    return { move: [0, -1] }
  elsif key == Terminal::TK_DOWN || key == Terminal::TK_J
    return { move: [0, 1] }
  elsif key == Terminal::TK_LEFT || key == Terminal::TK_H
    return { move: [-1, 0] }
  elsif key == Terminal::TK_RIGHT || key == Terminal::TK_L
    return { move: [1, 0] }
  end

  #exit
  if key == Terminal::TK_ESCAPE || key == Terminal::TK_CLOSE
    return { quit: true }
  end
  #no key pressed
  {}
end
