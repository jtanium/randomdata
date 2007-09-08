# al_cities.rb.rb
# July 18, 2007
#
cities = Array.new

File.open("al_cities.txt", "r") do |file|
  while row = file.gets do
    row.split(/\t/).each do |city|
      unless city.nil? || city.empty?
        cities << city.strip
      end
    end
#    city1, city2, city3, city4, city5 = row.split(/\t/)
#    unless city1.nil? or city1.empty?
#      cities << city1.strip
#    end
#    unless city2.nil? or city2.empty?
#      cities << city2.strip
#    end
#    unless city3.nil? or city3.empty?
#      cities << city3.strip
#    end
#    unless city4.nil? or city4.empty?
#      cities << city4.strip
#    end
  end
end

cities.sort.each { |city| puts "- #{city}" }
puts "\n\nTotal cities: #{cities.length}"