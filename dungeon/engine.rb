require './lib/BearLibTerminal/BearLibTerminal.rb'

Terminal.open

while Terminal.read == Terminal::TK_CLOSE
  Terminal.clear
  Terminal.print(1, 1, '@')
  Terminal.refresh
end

Terminal.close
