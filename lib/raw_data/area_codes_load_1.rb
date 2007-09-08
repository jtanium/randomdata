require 'rubygems'
require 'hpricot'
require 'sqlite3'

db = SQLite3::Database.new( 'area_codes.sqlite' )
db.execute('PRAGMA synchronous = OFF;')
Dir.glob('area_codes/*.htm') do |file|
  state_abbr = file[11..12].upcase
  puts "Processing #{file}"
  doc = open(file) { |f| Hpricot(f) }
  doc.search("td a").each do |a|
    text = a.inner_text
    next unless text.match(/\(\d{3}\)-\d{3} [A-Z0-9 ]+/)
    area_code = text[1..3]
    prefix = text[6..8]
    city = text[10..-1]
    sql = "INSERT INTO area_codes (state_abbr, area_code, prefix, city) VALUES ('#{state_abbr}', '#{area_code}', '#{prefix}', '#{city}');"
    # puts "Executing: #{sql}"
    db.execute(sql)
  end
end
