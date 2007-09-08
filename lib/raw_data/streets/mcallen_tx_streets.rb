# mcallen_tx_streets.rb.rb
# July 26, 2007
#
require 'rubygems'
require 'sqlite3'

my_dir = File.dirname(File.expand_path(__FILE__))
$db = SQLite3::Database.new( my_dir + '/../../db/database.sqlite' )
$db.execute('PRAGMA synchronous = OFF;')

require '../execute_safe.rb'

File.open('mcallen_tx_streets.txt') do |file|
  while line = file.gets
    execute_safe("INSERT INTO street_names (name) VALUES (?)", [line.strip])
  end
end
