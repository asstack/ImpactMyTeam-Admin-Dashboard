stock_colors = {
  "Impact Red" => "b82424",
  "Blitz Blue" => "0000c4",
  "Carbon Black" => "3a3a3a",
  "Adrenaline Yellow" => "fdfc02",
  "Gridiron Green" => "02710b",
  "Navy Blue" => "14135f",
  "Custom" => 'ffffff'
}

print "\nColors"

stock_colors.each do |name, hex|
  ProductColor.find_or_create_by_name!(name: name, hex: hex)
  print '.'
end

puts 'done.'
