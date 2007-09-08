# execute_safe.rb
# July 26, 2007
#

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
