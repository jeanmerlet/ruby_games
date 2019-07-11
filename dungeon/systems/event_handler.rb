module EventHandler

  def self.read(active_cmd_domains)
    if BLT.has_input?
      process_input(BLT.read, active_cmd_domains)
    else
      return nil
    end
  end

  def self.process_input(input, active_cmd_domains)
    action = {}
    active_cmd_domains.each do |cmd_domain|
      case cmd_domain

      when :main
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
        #targetting
        when BLT::TK_TAB
          action[:next_target] = true
        #picking up items
        when BLT::TK_G
          action[:pick_up] = true
        #opening inventory
        when BLT::TK_I
          action[:inventory] = true
        end

      when :menu
        # select menu option: a..z are mapped to 4..29 in BLT
        if (4..29) === input 
          action[:option_index] = [*(0..25)][input - 4]
        end

      when :quit
        case input
        #close current screen
        when BLT::TK_ESCAPE
          action[:quit] = true
        end

      end
      return action if !action.empty?
    end
    return action
  end
end
