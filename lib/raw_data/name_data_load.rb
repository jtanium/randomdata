# load_name_data.rb
# July 26, 2007
#
require 'rubygems'
require 'sqlite3'
require 'active_support/core_ext/string'

my_dir = File.dirname(File.expand_path(__FILE__))
$db = SQLite3::Database.new( my_dir + '/../db/database.sqlite' )
$db.execute('PRAGMA synchronous = OFF;')

def execute_safe(sql, args)
  attempt_count = 0
  begin
    $db.execute(sql, args)
  rescue SQLite3::BusyException => e
    if attempt_count < 5
      puts "\nSQLite is busy, attempt ##{attempt_count}"
      attempt_count += 1
      retry
    else
      raise e
    end
  rescue SQLite3::SQLException => e
    if e.message.eql? 'column name is not unique'
      print "."
    else
      puts "\nUnable to insert '#{args[0]}': #{e.message}"
    end
  end
end

def load_first_names(file, gender)
  while line = file.gets do
    execute_safe("INSERT INTO first_names (name, gender) VALUES (?, ?)", [line[0..14].strip.titleize, gender])
    print 'f'
  end
end

def load_last_names(file)
  while line = file.gets do
    execute_safe("INSERT INTO last_names (name) VALUES (?)", [line[0..14].strip.titleize])
    print 'l'
  end
end

# load_first_names(File.open('name_data/names.female.txt'), 'female')
load_first_names(File.open('name_data/female_names.txt'), 'female')
# load_first_names(File.open('name_data/names.male.txt'), 'male')
load_first_names(File.open('name_data/male_names.txt'), 'male')
# load_last_names(File.open('name_data/names.last.txt'))
load_last_names(File.open('name_data/last_names.txt'))