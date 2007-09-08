# nopl_street_names.rb
# July 26, 2007
#
require 'rubygems'
require 'hpricot'
require 'sqlite3'

my_dir = File.dirname(File.expand_path(__FILE__))
$db = SQLite3::Database.new( my_dir + '/../../db/database.sqlite' )
$db.execute('PRAGMA synchronous = OFF;')

require '../execute_safe.rb'

Dir.glob('nopl_street_names/*.htm') do |file_name|
  doc = open(file_name) { |f| Hpricot(f) }
  doc.search('tr td:first-child').each do |element|
    street_name = element.inner_text.chomp.strip
    next if street_name.eql? 'STREET NAME'
#    puts 'street name: ' + street_name
    execute_safe("INSERT INTO street_names (name) VALUES (?)", [street_name])
  end
end
