module FieldOfView

  @@transform = [
                  [1,  0,  0, -1, -1,  0,  0,  1],
                  [0,  1, -1,  0,  0, -1,  1,  0],
                  [0,  1,  1,  0,  0, -1, -1,  0],
                  [1,  0,  0,  1, -1,  0,  0, -1],
                ] 

  def light(x, y)
    tile = @map.tiles[x][y]
    if tile.blocked
      BLT.print(x, y, "[color=light_wall][0x1003]")
    else
      BLT.print(x, y, "[color=light_ground][0x100E]")
    end
    tile.explored = true
  end

  def fov(x, y, r)
    8.times do |oct|
      shadowcast(x, y, 1, 1.0, 0.0, r,
        @@transform[0][oct], @@transform[1][oct],
        @@transform[2][oct], @@transform[3][oct])
    end
  end

  def shadowcast(cx, cy, row, cone_slope1, cone_slope2, r, xx, xy, yx, yy)
    return if cone_slope1 < cone_slope2
    r_sq = r**2
    (row..r).each do |j|
      dx, dy = -j - 1, -j
      blocked = false
      while dx <= 0
        dx += 1
        mx, my = cx + dx * xx + dy * xy, cy + dx * yx + dy * yy
        l_slope, r_slope = (dx-0.5)/(dy+0.5), (dx+0.5)/(dy-0.5)
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
              shadowcast(cx, cy, j+1, cone_slope1, l_slope, r, xx, xy, yx, yy)
              new_start = r_slope
            end
          end
        end
      end
      break if blocked
    end
  end
end
