module Config

  SCREEN_WIDTH = 106
  SCREEN_HEIGHT = 38

  SIDE_PANEL_WIDTH = 44
  VERT_PANEL_HEIGHT = 7

  def self.blt_config
    BLT.set("window: size=#{SCREEN_WIDTH.to_s}x#{SCREEN_HEIGHT.to_s}")
    BLT.set("window: cellsize=8x16")

    BLT.set("font: ./tilesets/OpenSans-Regular.ttf, size=10")
    BLT.set("gui font: ./tilesets/OpenSans-Regular.ttf, size=12")
    BLT.set("char font: ./tilesets/OpenSans-Regular.ttf, size=12, spacing=2x1")
    BLT.set("bold font: ./tilesets/OpenSans-Bold.ttf, size=12, spacing=2x1")
    BLT.set("0xE000: ./tilesets/targetting.png, spacing=2x1")
    BLT.set("0xE001: ./tilesets/bar_equals.png, spacing=2x1")
    BLT.set("palette.unlit = 40,40,40")
    BLT.set("palette.light_wall = 70,70,90")
    BLT.set("palette.light_floor = 220,220,150")
  end
end
