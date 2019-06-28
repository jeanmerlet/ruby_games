module ShapeMath
  def circ_rect_intersect?(circ, rect)
    r = circ.r + 1
    if rect.x1 <= circ.x && circ.x <= rect.x2 && rect.y1 <= circ.y && circ.y <= rect.y2
      (circ.y - rect.y1).abs <= r ||
      (circ.y - rect.y2).abs <= r ||
      (circ.x - rect.x1).abs <= r ||
      (circ.x - rect.x2).abs <= r
    elsif rect.x1 <= circ.x && circ.x <= rect.x2
      (circ.y - rect.y1).abs <= r ||
      (circ.y - rect.y2).abs <= r
    elsif rect.y1 <= circ.y && circ.y <= rect.y2
      (circ.x - rect.x1).abs <= r ||
      (circ.x - rect.x2).abs <= r
    else
      (circ.x-rect.x1)**2 + (circ.y-rect.y1)**2 < r**2 ||
      (circ.x-rect.x1)**2 + (circ.y-rect.y2)**2 < r**2 ||
      (circ.x-rect.x2)**2 + (circ.y-rect.y1)**2 < r**2 ||
      (circ.x-rect.x2)**2 + (circ.y-rect.y2)**2 < r**2
    end
  end
end
