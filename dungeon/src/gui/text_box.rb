module TextBox

  def self.render(viewport, header, header_length, desc)
    width = viewport.width*8/5
    lines = desc.scan(/.{1,#{width-1}}[ .]/)
    height = lines.size
    x, y = viewport.width - width/2, viewport.height/2 - height/2 - 2
    header_start_x = viewport.width - header_length/2
    BLT.clear_area(x-2, y-1, width+2, height+4)
    BLT.print(header_start_x, y, "[font=gui]#{header}")
    lines.each do |line|
      BLT.print(x, y+2, "#{line}")
      y += 1
    end
  end
end
