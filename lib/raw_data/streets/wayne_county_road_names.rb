# wayne_county_road_names.rb.rb
# July 26, 2007
#
require 'rubygems'
require 'hpricot'
require 'sqlite3'
require 'active_support/core_ext/string'

my_dir = File.dirname(File.expand_path(__FILE__))
$db = SQLite3::Database.new( my_dir + '/../../db/database.sqlite' )
$db.execute('PRAGMA synchronous = OFF;')

require '../execute_safe.rb'

puts "Opening file..."
doc = open('wayne_county_road_names.html') { |f| Hpricot(f) }
puts "Searching..."
doc.search('tr[@bgcolor="#ffffcc"] td:first-child').each do |element|
  street_name = element.next_sibling.inner_text.chomp.strip.titleize
#  puts 'street name: ' + street_name
  execute_safe("INSERT INTO street_names (name) VALUES (?)", [street_name])
end
