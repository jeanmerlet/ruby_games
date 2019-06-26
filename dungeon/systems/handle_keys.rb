module HandleKeys

  def parse_input(key)
    action = {}

    case key
    #movement
    when BLT::TK_UP, BLT::TK_K
      action[:move] = [0, -1]
    when BLT::TK_DOWN, BLT::TK_J
      action[:move] = [0, 1]
    when BLT::TK_LEFT, BLT::TK_H
      action[:move] = [-1, 0]
    when BLT::TK_RIGHT, BLT::TK_L
      action[:move] = [1, 0]
    #close game
    when BLT::TK_ESCAPE, BLT::TK_CLOSE
      action[:quit] = true
    end

    action
  end
end
