module EventHandler

  def self.read
    action = {}
    if BLT.has_input?
      input = BLT.read
      case input

      #movement
      when BLT::TK_UP, BLT::TK_KP_8, BLT::TK_K
        action[:move] = [0, -1]
      when BLT::TK_DOWN, BLT::TK_KP_2, BLT::TK_J
        action[:move] = [0, 1]
      when BLT::TK_LEFT, BLT::TK_KP_4, BLT::TK_H
        action[:move] = [-1, 0]
      when BLT::TK_RIGHT, BLT::TK_KP_6, BLT::TK_L
        action[:move] = [1, 0]
      when BLT::TK_KP_7, BLT::TK_Y
        action[:move] = [-1, -1]
      when BLT::TK_KP_9, BLT::TK_U
        action[:move] = [1, -1]
      when BLT::TK_KP_3, BLT::TK_N
        action[:move] = [1, 1]
      when BLT::TK_KP_1, BLT::TK_B
        action[:move] = [-1, 1]
      when BLT::TK_KP_5, BLT::TK_PERIOD
        action[:move] = [0, 0]

      #close game
      when BLT::TK_ESCAPE
        action[:quit] = true
      end
      return action
    else
      return nil
    end
  end
end
