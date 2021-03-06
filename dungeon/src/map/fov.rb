module FieldOfView

  # this is a Ruby port of Adam Milazzo's modified recursive shadowcasting
  # algorithm:
  # http://www.adammil.net/blog/v125_Roguelike_Vision_Algorithms.html
  #
  # the main differences from standard shadowcasting are as follows:
  #
  # I. walls are beveled to allow for less blind corners. a wall can be beveled
  # in 1, 2, or all 4 of its corners (nw, ne, se, sw). each of the corners is
  # beveled if the two adjacent-most tiles are both non-blocking tiles. this
  # could be implemented as part of the algorithm, but here is implemented as
  # part of map creation, which probably performs better.
  #
  # II. non-blocking (e.g. wall) tiles are only lit if their inner square
  # (width 1/2) is hit by the light cone, and wall tiles if their beveled shape
  # is hit. this results in more expansive walls and more reasonable lighting
  # through narrow spaces.
  #
  # III. 0-width lightbeams do not project light. this is the only way to light
  # diagonally through two diagonally adjacent walls when shadowcasting, but is
  # no longer necessary with beveled walls.
  #
  # below is a 2D matrix of multipliers for transforming the offsets from the
  # origin, dx and dy, into map coordinates for a standard roguelike left
  # handed coordinate system. using these transformations prevents the need
  # for 8 different pairs of slope equations and dx, dy iterations.

  @@mult = [
            [1,  0,  0,  1, -1,  0,  0, -1],  #xx
            [0,  1,  1,  0,  0, -1, -1,  0],  #xy
            [0,  1, -1,  0,  0, -1,  1,  0],  #yx
            [1,  0,  0, -1, -1,  0,  0,  1]   #yy
           ] 

  # the octants and corresponding multipliers are indexed as below:
  #
  # \ 0 | 7 /
  #  \  |  /
  # 1 \ | / 6
  #    \|/   
  # ----@----
  #    /|\   
  # 2 / | \ 5
  #  /  |  \ 
  # / 3 | 4 \
  #
  # the cast_light code uses the transformation:
  # map_x = origin_x + dx * xx + dy * xy
  # map_y = origin_y + dx * yx + dy * yy
  #
  # the result is that each octant of the game map is mapped to octant 0 for
  # the purposes of the cast_light function's calculations.

  def self.do_fov(map, entity)
    # increasing (or reducing) radius by 0.5 accounts for the tile width of the
    # origin to render a more accurately circular-looking field of view. it is
    # increased here to ensure the FoV extends radius number of tiles.
    x, y = entity.x, entity.y
    fov_id, radius = entity.fov_id, entity.fov_r + 0.5
    light(map, fov_id, x, y)
    8.times do |oct|
      cast_light(map, fov_id, oct, x, y, radius, 1, 1.0, 0.0,
        @@mult[0][oct], @@mult[1][oct],
        @@mult[2][oct], @@mult[3][oct])
    end
  end

  private

  def self.cast_light(map, fov_id, oct, x, y, r, row, cast_start, cast_end,
                      xx, xy, yx, yy)
    return if cast_start <= cast_end
    r_sq = r**2
    (row..r).each do |j|
      dx, dy = -j-1, -j
      row_blocked = false
      while dx < 0
        dx += 1
        # transform x, y, dx, and dy into map coordinates
        map_x, map_y = x + dx * xx + dy * xy, y + dx * yx + dy * yy
        if !map.out_of_bounds?(map_x, map_y)
          tile = map.tiles[map_x][map_y]
        else
          next
        end
        dyo = 0.5
        # modify dy offset as needed based on tile bevel
        case oct
        when 0, 1
          dyo = 0 if tile.bevel_sw || tile.bevel_ne
        when 2, 3
          dyo = 0 if tile.bevel_se || tile.bevel_nw
        when 4, 5
          dyo = 0 if tile.bevel_sw || tile.bevel_ne
        else
          dyo = 0 if tile.bevel_se || tile.bevel_nw
        end
        # calculate 'left' and 'right' slopes from the center of the origin
        # to the outside-most points of the tile we are considering.
        l_slope, r_slope = (dx-0.5)/(dy+dyo), (dx+0.5)/(dy-dyo)
        # calculate the 'left' and 'right' slopes of the inner square of the
        # tile we are considering.
        inner_l_slope, inner_r_slope = (dx-0.25)/(dy+0.25), (dx+0.25)/(dy-0.25)
        if (cast_start < r_slope && tile.blocked) ||
           (cast_start < inner_r_slope && !tile.blocked)
          next
        elsif (cast_end > l_slope && tile.blocked) ||
              (cast_end > inner_l_slope && !tile.blocked)
          break
        else
          light(map, fov_id, map_x, map_y) if (dx*dx + dy*dy) < r_sq
          if row_blocked
            # we are scanning a row of blocked tiles
            if tile.blocked
              child_cast_start = r_slope
              next
            else
            # mark the row no longer blocked to allow for another child scan
              row_blocked = false
              cast_start = child_cast_start
            end
          else
            # start a child scan if the current tile blocks light and the scan
            # is not on the last row to be scanned.
            if tile.blocked
              row_blocked = true
              cast_light(map, fov_id, oct, x, y, r, j+1, cast_start, l_slope,
                         xx, xy, yx, yy)
              child_cast_start = r_slope
            end
          end
        end
      end
      break if row_blocked
    end
  end

  def self.light(map, fov_id, x, y)
    map.tiles[x][y].explored = true
    map.fov_tiles[x][y] = fov_id
  end
end
