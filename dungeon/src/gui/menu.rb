module Menu

  def self.render(viewport, header, options)
    max_opt = (options.empty? ? 0 : options.max_by { |key, opt| opt.size }[1].size)
    width = [max_opt, 40].max
    height = options.size
    x = viewport.width - width/2
    y = viewport.height/2 - height/2 - 3
    header_start_x = viewport.width - header.length/2
    BLT.clear_area(x-2, y-1, width+2, height+6)
    BLT.print(header_start_x, y, "[font=gui]#{header}")
    BLT.print(x, y+2, "[[Esc]] to close, [[a-z]] to select option:")
    options.each do |key, option|
      BLT.print(x, y+4, "#{key.to_s}. #{option}")
      y += 1
    end
  end
end
