module FieldOfView

  @@mult = [
            [1,  0,  0,  1, -1,  0,  0, -1],
            [0,  1,  1,  0,  0, -1, -1,  0],
            [0,  1, -1,  0,  0, -1,  1,  0],
            [1,  0,  0, -1, -1,  0,  0,  1]
           ] 

  def light(x, y)
    @map.tiles[x][y].explored = true
    @map.fov_tiles[x][y] = @player.fov_id
  end

  def out_of_bounds?(x, y)
    x < 0 || x > @map.width-1 || y < 0 || y > @map.height-1
  end

  def fov(x, y, r)
    light(x, y)
    8.times do |oct|
      shadowcast(oct, x, y, 1, 1.0, 0.0, r,
        @@mult[0][oct], @@mult[1][oct],
        @@mult[2][oct], @@mult[3][oct])
    end
  end

  def shadowcast(oct, cx, cy, row, cone_slope1, cone_slope2, r, xx, xy, yx, yy)
    return if cone_slope1 < cone_slope2
    r_sq = r**2
    (row..r).each do |j|
      dx, dy = -j - 1, -j
      blocked = false
      while dx <= -1
        dx += 1
        mx, my = cx + dx * xx + dy * xy, cy + dx * yx + dy * yy
        next if out_of_bounds?(mx, my)
        tile = @map.tiles[mx][my]
        dxo, dyo = 0.5, 0.5
        if oct == 0 || oct == 1
          dxo = 0 if tile.bevel_sw
          dyo = 0 if tile.bevel_ne
        elsif oct == 2 || oct == 3
          dxo = 0 if tile.bevel_se
          dyo = 0 if tile.bevel_nw
        elsif oct == 4 || oct == 5
          dxo = 0 if tile.bevel_ne
          dyo = 0 if tile.bevel_sw
        else
          dxo = 0 if tile.bevel_nw
          dyo = 0 if tile.bevel_se
        end
        l_slope, r_slope = (dx-dxo)/(dy+0.5), (dx+0.5)/(dy-dyo)
        if cone_slope1 < r_slope
          next
        elsif cone_slope2 > l_slope
          break
        else
          light(mx, my) if (dx*dx + dy*dy) < r_sq
          if blocked
            if @map.tiles[mx][my].blocked
              new_start = r_slope
              next
            else
              blocked = false
              cone_slope1 = new_start
            end
          else
            if @map.tiles[mx][my].blocked && j < r
              blocked = true
              shadowcast(oct, cx, cy, j+1, cone_slope1, l_slope, r, xx, xy, yx, yy)
              new_start = r_slope
            end
          end
        end
      end
      break if blocked
    end
  end
end
