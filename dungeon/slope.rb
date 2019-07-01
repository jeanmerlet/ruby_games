def slope(dx, dy)
  l_slope, r_slope = (dx-0.5)/(dy+0.5), (dx+0.5)/(dy-0.5) 
  puts "l_slope: #{l_slope} r_slope: #{r_slope}"
end
print "dx: "
dx = gets.chomp.to_i
print "dy: "
dy = gets.chomp.to_i
slope(dx, dy)
