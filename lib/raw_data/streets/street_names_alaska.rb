# street_names_alaska.rb.rb
# July 26, 2007
#
require 'rubygems'
require 'sqlite3'
require 'active_support/core_ext/string'

my_dir = File.dirname(File.expand_path(__FILE__))
$db = SQLite3::Database.new( my_dir + '/../../db/database.sqlite' )
$db.execute('PRAGMA synchronous = OFF;')

require '../execute_safe.rb'

File.open('street_names_alaska.csv') do |file|
  while line = file.gets
    columns = line.split('|')
    prefix_dir = columns[0].strip.titleize
    street_name = columns[1].strip.titleize
    street_type = columns[2].strip.titleize
#    suffix_dir = columns[3].strip.titleize
    next if street_type.eql? 'Ramp'
    prefix_dir = '' unless prefix_dir.match(/(North|East|South|West)/)
    complete_name = prefix_dir
    complete_name << ' ' unless prefix_dir.empty?
    complete_name << street_name
    complete_name << ' '
    complete_name << street_type
#    puts complete_name
    execute_safe("INSERT INTO street_names (name) VALUES (?)", [complete_name])
  end
end
