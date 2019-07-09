module ShapeMath
  def self.circ_rect_intersect?(c, r, overlap)
    rad = c.r + 1 - overlap
    if r.x1 <= c.x && c.x <= r.x2 && r.y1 <= c.y && c.y <= r.y2
      (c.y - r.y1).abs <= rad ||
      (c.y - r.y2).abs <= rad ||
      (c.x - r.x1).abs <= rad ||
      (c.x - r.x2).abs <= rad
    elsif r.x1 <= c.x && c.x <= r.x2
      (c.y - r.y1).abs <= rad ||
      (c.y - r.y2).abs <= rad
    elsif r.y1 <= c.y && c.y <= r.y2
      (c.x - r.x1).abs <= rad ||
      (c.x - r.x2).abs <= rad
    else
      rad_sq = rad**2
      (c.x-r.x1)**2 + (c.y-r.y1)**2 < rad_sq ||
      (c.x-r.x1)**2 + (c.y-r.y2)**2 < rad_sq ||
      (c.x-r.x2)**2 + (c.y-r.y1)**2 < rad_sq ||
      (c.x-r.x2)**2 + (c.y-r.y2)**2 < rad_sq
    end
  end

  def self.rect_rect_intersect?(r1, r2, overlap)
    r1.x1 <= r2.x2 - overlap && r2.x2 - overlap >= r1.x1 &&
    r1.y1 <= r2.y2 - overlap && r2.y2 - overlap >= r1.y1
  end

  def self.circ_circ_intersect?(c1, c2, overlap)
    x = c1.x - c2.x
    y = c1.y - c2.y
    r = c1.r + c2.r + 1 - overlap
    x*x + y*y < r*r
  end
end
