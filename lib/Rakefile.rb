# Rakefile.rb
# July 18, 2007
#

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'rubygems'
require 'active_record'  

require 'database_config.rb'
   
task :default => :migrate  
   
desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"  
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )  
end  
   
task :environment do
  ActiveRecord::Base.establish_connection(DatabaseConfig.as_hash)
  ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))  
end
