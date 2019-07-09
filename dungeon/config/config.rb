module Config

  SCREEN_WIDTH = 160
  SCREEN_HEIGHT = 50

  def self.blt_config
    BLT.set("window: size=#{SCREEN_WIDTH.to_s}x#{SCREEN_HEIGHT.to_s}")
    BLT.set("window: cellsize=8x16")
    BLT.set("extra_bold font: ./tilesets/OpenSans-ExtraBold.ttf, size=12, spacing=2x1")
    BLT.set("reg font: ./tilesets/OpenSans-Regular.ttf, size=12, spacing=2x1")
    BLT.set("bold font: ./tilesets/OpenSans-Bold.ttf, size=12, spacing=2x1")
    BLT.set("font: ./tilesets/OpenSansCondensed-Bold.ttf, size=11")
    BLT.set("palette.gray = 40,40,40")
    BLT.set("palette.light_wall = 70,70,90")
    BLT.set("palette.light_floor = 220,220,150")
  end
end
