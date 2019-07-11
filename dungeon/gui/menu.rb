module Menu

  def self.display_menu(header, options)
    max_opt = (options.empty? ? 0 : options.max_by { |key, opt| opt.size }[1])
    width = [max_opt, 40].max
    height = options.size
    x = Config::SCREEN_WIDTH/2 - width/2
    y = Config::SCREEN_HEIGHT/2 - height/2 - 4
    header_start_x = Config::SCREEN_WIDTH/2 - header.length/2
    BLT.clear_area(x-2, y, width+2, height+5)
    BLT.print(header_start_x, y, "[font=gui]#{header}")
    BLT.print(x, y+2, "[[Esc]] to close, [[a-z]] to select option:")
    options.each do |key, option|
      BLT.print(x, y+4, "[font=gui]#{key.to_s}.[/font] #{option}")
      y += 1
    end
  end
end
