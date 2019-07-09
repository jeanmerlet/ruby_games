module Config

  SCREEN_WIDTH = 80
  SCREEN_HEIGHT = 50

  def self.blt_config
    BLT.set("window: size=#{SCREEN_WIDTH.to_s}x#{SCREEN_HEIGHT.to_s}")
    BLT.set("window: cellsize=16x16")
    BLT.set("extra_bold font: ./tilesets/OpenSans-ExtraBold.ttf, size=12")
    BLT.set("font: ./tilesets/OpenSans-Regular.ttf, size=12")
    BLT.set("bold font: ./tilesets/OpenSans-Bold.ttf, size=12")
    BLT.set("log font: ./tilesets/OpenSansCondensed-Light.ttf, size=11")
    BLT.set("palette.gray = 40,40,40")
    BLT.set("palette.light_wall = 70,70,90")
    BLT.set("palette.light_floor = 220,220,150")
  end
end
