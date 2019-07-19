class GUI
  attr_accessor :target_info
  attr_reader :hp_bar, :log

  def initialize(player)
    @bar_size = 20
    @hp_x, @hp_y = Config::SCREEN_WIDTH - Config::SIDE_PANEL_WIDTH, 0
    @log_x, @log_y = 2, Config::SCREEN_HEIGHT - Config::VERT_PANEL_HEIGHT
    @log_w, @log_h = 62, 5
    @hp_bar = Bar.new(@hp_x, @hp_y, @bar_size, 'HP', 'red', player.combat.hp)
    @log = Log.new(@log_x, @log_y, @log_w, @log_h)
  end

  def render
    @hp_bar.render
    @log.render
    @target_info.render if @target_info
  end
end
