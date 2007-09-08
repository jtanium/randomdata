# us_area_codes.rb.rb
# July 18, 2007
#

require 'net/http'
require 'uri'
require 'rubygems'
require 'hpricot'

require File.dirname(File.expand_path(__FILE__)) + '/../../models'

STATE_ABBR = {
  'AL' => 'Alabama',
  'AK' => 'Alaska',
  'AS' => 'America Samoa',
  'AZ' => 'Arizona',
  'AR' => 'Arkansas',
  'CA' => 'California',
  'CO' => 'Colorado',
  'CT' => 'Connecticut',
  'DE' => 'Delaware',
  'DC' => 'District of Columbia',
  'FM' => 'Micronesia1',
  'FL' => 'Florida',
  'GA' => 'Georgia',
  'GU' => 'Guam',
  'HI' => 'Hawaii',
  'ID' => 'Idaho',
  'IL' => 'Illinois',
  'IN' => 'Indiana',
  'IA' => 'Iowa',
  'KS' => 'Kansas',
  'KY' => 'Kentucky',
  'LA' => 'Louisiana',
  'ME' => 'Maine',
  'MH' => 'Islands1',
  'MD' => 'Maryland',
  'MA' => 'Massachusetts',
  'MI' => 'Michigan',
  'MN' => 'Minnesota',
  'MS' => 'Mississippi',
  'MO' => 'Missouri',
  'MT' => 'Montana',
  'NE' => 'Nebraska',
  'NV' => 'Nevada',
  'NH' => 'New Hampshire',
  'NJ' => 'New Jersey',
  'NM' => 'New Mexico',
  'NY' => 'New York',
  'NC' => 'North Carolina',
  'ND' => 'North Dakota',
  'OH' => 'Ohio',
  'OK' => 'Oklahoma',
  'OR' => 'Oregon',
  'PW' => 'Palau',
  'PA' => 'Pennsylvania',
  'PR' => 'Puerto Rico',
  'RI' => 'Rhode Island',
  'SC' => 'South Carolina',
  'SD' => 'South Dakota',
  'TN' => 'Tennessee',
  'TX' => 'Texas',
  'UT' => 'Utah',
  'VT' => 'Vermont',
  'VI' => 'Virgin Island',
  'VA' => 'Virginia',
  'WA' => 'Washington',
  'WV' => 'West Virginia',
  'WI' => 'Wisconsin',
  'WY' => 'Wyoming'
}

ZIP_CODES = [
  PostalCode.new(:postal_code => '12345'), 
#  PostalCode.new(:postal_code => '23456'), 
#  PostalCode.new(:postal_code => '34567'), 
#  PostalCode.new(:postal_code => '45678'), 
#  PostalCode.new(:postal_code => '56789'), 
  PostalCode.new(:postal_code => '67890')]
  
ZIP_CODES.each { |zip| zip.save }

def lookup_zip_codes(city)
#  response = Net::HTTP.post_form(URI.parse('http://zip4.usps.com/zip4/zcl_1_results.jsp'), 
#      {'city' => city.name.upcase, 'state' => city.state_province.abbreviation.upcase, 'visited' => '1', 'pagenumber' => '0'})
#
#  doc = Hpricot(response.body)
#  zip_codes = Array.new
#  doc.search("//td[@class='main']").each do |element|
#    zip_codes << element.inner_text.strip.match(/\d{5}/)
#  end
#  return zip_codes
 
  city.postal_codes = ZIP_CODES
#  ['12345', '23456', '34567', '45678', '56789', '67890']
end

def puts_city(city)
  puts "city: #{city.name}"
  puts "\tstate: #{city.state_province.inspect}"
  area_codes = Array.new
  city.area_codes.each { |a| area_codes << a.npa }
  puts "\tarea_codes: #{area_codes.inspect}"
  zips = Array.new
  city.postal_codes.each { |z| zips << z.postal_code }
  puts "\tpostal_codes: #{zips.inspect}"
end

def get_state_province(state_abbr)
  state = StateProvince.find_by_abbreviation(state_abbr)
  if state.nil?
    puts "Unable to find state by abbreviation: #{state_abbr}"
    state = StateProvince.new(:abbreviation => state_abbr, :name => STATE_ABBR[state_abbr], :country => Country.find_by_abbreviation('US'))
    unless state.save
      puts "Unable to save state: #{state.inspect}"
      exit
    end
  end
  puts "returning state: #{state.inspect}"
  return state
end

def get_city(city_name, state_id)
  city = City.find_by_name_and_state_province_id(city_name, state_id)
  if city.nil?
    city = City.new(:name => city_name, :state_province_id => state_id)
  end
  return city
end

state_abbr = ''
overlay_codes = ''
#out_file = File.open("data.yml", "w+")
File.open("us_area_codes.txt") do |file|
  while row = file.gets do
    col1, col2, col3 = row.split(/\t/)
    col1.strip!
    unless col2.nil?
      col2.strip!
    end
    unless col3.nil?
      col3.strip!
    end
    if col1.match(/[A-Z]{2}/)
      state_abbr = col1
      area_code = col2
      cities_list = col3
    elsif col1.match(/\d{2}/)
      area_code = col1
      cities_list = col2
    else
      puts "Unrecognized column1 data: #{col1}"
      exit
    end

    if cities_list.nil? || cities_list.empty?
      if overlay_codes.empty?
        overlay_codes = area_code
      else
        overlay_codes << '/' + area_code
      end
      next
    else
      unless overlay_codes.empty?
        area_code = overlay_codes + '/' + area_code
        overlay_codes = ''
      end
    end
    
    city_names = cities_list.split(',')
    state = get_state_province(state_abbr)
    city_names.each do |city_name| 

      city = get_city(city_name, state.id) # City.new({:name => city_name.strip})

      area_code.split('/').each do |npa|
        city.area_codes << (AreaCode.find_by_npa(npa) || AreaCode.new(:npa => npa))
      end
      lookup_zip_codes(city)
#      if area_codes.empty?
#        puts "No area codes found for '#{city_name}, #{state_abbr}'"
#        exit
#      end
#      zip_codes = Array.new
#      lookup_zip_codes(state_abbr, city_name).each do |zip_code|
#        z = (PostalCode.find_by_postal_code(zip_code) || PostalCode.new(:postal_code => zip_code))
#        z.save if z.new_record?
#        city.postal_codes << z
#      end
#      if zip_codes.empty?
#        puts "No zip codes found for '#{city_name}, #{state_abbr}'"
#        exit
#      end
#      city.state_province = state
#      city.area_codes = area_codes
#      city.postal_codes = zip_codes
      puts "city.valid?: #{city.valid?}"
      puts_city(city)
      city.save if city.valid?
    end 
  end
end
