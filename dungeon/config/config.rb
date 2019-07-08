module Config

  SCREEN_WIDTH = 80
  SCREEN_HEIGHT = 50

  def blt_config
    BLT.set("window: size=#{SCREEN_WIDTH.to_s}x#{SCREEN_HEIGHT.to_s}")
    BLT.set("window: cellsize=16x16")
    BLT.set("extra_bold font: ./tilesets/OpenSans-ExtraBold.ttf, size=12")
    BLT.set("bold font: ./tilesets/OpenSans-Bold.ttf, size=12")
    BLT.set("font: ./tilesets/OpenSans-Regular.ttf, size=12")
    BLT.set("palette.gray = 40,40,40")
    BLT.set("palette.light_wall = 70,70,90")
    BLT.set("palette.light_floor = 220,220,150")
  end

  def map_config
    @map_w, @map_h = 64, 43
    @side_min, @side_max = 3, 4
    @room_tries = 60
    @monster_max = 3
  end

  def fov_config
    @fov_radius = 10
    @refresh_fov = true
  end

  def ui_config
    @panel_w = 16
    @panel_h = 30
    @char_panel_x = SCREEN_WIDTH - @panel_w - 1
    @char_panel_y = 0
    @log_w, @log_h = 59, 5
    @log_x, @log_y = 1, SCREEN_HEIGHT - @log_h
  end
end
