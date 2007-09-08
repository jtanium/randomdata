require 'rubygems'
require 'sqlite3'
my_dir = File.dirname(File.expand_path(__FILE__))
require my_dir + '/../models.rb'

def log(msg)
  puts '[process_area_codes_db.rb] ' + msg
end

area_codes_db = SQLite3::Database.new( my_dir + '/area_codes.sqlite' )

City.find(:all).each do |city|
  area_codes_sql = "select area_code from area_codes where state_abbr = ? and city = ?"
  area_code_count = city.area_codes.length
  area_codes_db.execute( area_codes_sql, [city.state_province.abbreviation, city.name.upcase]) do |row|
    npa = row[0]
    area_code = AreaCode.find_by_npa(npa)
    if area_code.nil?
      log "Unable to find AreaCode: #{npa}"
      area_code = AreaCode.new(:npa => npa)
      area_code.save
    end
    city.area_codes << area_code unless city.area_codes.index(area_code)
  end
end

