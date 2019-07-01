module Config

  SCREEN_W = 80
  SCREEN_H = 50
  TILESET = "./tilesets/arial10x10.png, size=10x10"

  def blt_config
    BLT.set("window: size=#{SCREEN_W.to_s}x#{SCREEN_H.to_s}")
    BLT.set("0x1000: #{TILESET}")
    BLT.set("palette.dark_wall = 0,0,100")
    BLT.set("palette.dark_ground = 50,50,150")
    BLT.set("palette.light_wall = 130,110,50")
    BLT.set("palette.light_ground = 200,180,50")
  end

  def map_config
    @map_w, @map_h = 80, 45
    @side_min, @side_max = 3, 5
    @room_tries = 70
    @monster_max = 3
  end

  def fov_config
    @fov_radius = 10
    @refresh_fov = true
  end
end
