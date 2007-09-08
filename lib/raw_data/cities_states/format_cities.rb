# wy_cities.rb
# July 19, 2007
#

File.open(ARGV[0]) do |file|
  while city = file.gets do
    print city.chomp.strip + ', '
  end
end
