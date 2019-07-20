module EventHandler

  def self.read(active_cmd_domains)
    if BLT.has_input?
      process_input(BLT.read, active_cmd_domains)
    else
      return nil
    end
  end

  private

  def self.process_input(input, active_cmd_domains)
    action = {}
    active_cmd_domains.each do |cmd_domain|
      case cmd_domain

      when :main
        case input
        # inspecting
        when BLT::TK_X
          action[:inspecting] = true
        # picking up items
        when BLT::TK_G
          action[:pick_up] = true
        # dropping items
        when BLT::TK_D
          action[:drop] = true
        # opening inventory
        when BLT::TK_I
          action[:inventory] = true
        when BLT::TK_S
          action[:save_and_quit] = true if BLT.check?(BLT::TK_CONTROL)
        when BLT::TK_Q
          action[:abandon] = true if BLT.check?(BLT::TK_CONTROL)
        end

      when :movement
        case input
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
        end

      when :targetting
        # rotate targets
        case input
        when BLT::TK_TAB
          action[:next_target] = true
        # select current target
        when BLT::TK_SPACE
          action[:select_target] = true
        end

      when :menu
        # select menu option: a..z are mapped to 4..29 in BLT
        if (4..29) === input 
          action[:option_index] = [*(0..25)][input - 4]
        end

      when :quit
        case input
        # close current screen
        when BLT::TK_ESCAPE
          action[:quit] = true
        end

      end
      return action if !action.empty?
    end
    return action
  end
end
