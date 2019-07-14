class GUI
  attr_reader :hp_bar, :target_info, :log

  def initialize(player)
    @side_panel_w, @bar_size = 17, 15
    @hp_x, @hp_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 0
    @targ_x, @targ_y = Config::SCREEN_WIDTH/2 - @side_panel_w, 10
    @log_w, @log_h = 78, 5
    @log_x, @log_y = 2, Config::SCREEN_HEIGHT - @log_h - 1

    @hp_bar = Bar.new(@hp_x, @hp_y, @bar_size, 'HP', 'red', player.combat.hp)
    @target_info = TargetInfo.new(@targ_x, @targ_y, 2*@side_panel_w)
    @log = Log.new(@log_x, @log_y, @log_w, @log_h)
  end

  def render
    @hp_bar.render
    @target_info.render
    @log.render
  end
end
