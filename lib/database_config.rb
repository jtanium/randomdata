# database_config.rb.rb
# July 19, 2007
#
class DatabaseConfig
  def self.as_hash
    {:adapter => 'sqlite3', :dbfile => File.dirname(File.expand_path(__FILE__)) + '/db/database.sqlite'}
  end
end
