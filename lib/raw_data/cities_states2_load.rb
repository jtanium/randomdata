# parse_places_zcta5.rb
# July 23, 2007
#

require 'net/http'
require 'uri'
require 'rubygems'
require 'hpricot'
require '../../../models.rb'

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

$usa = Country.find_by_abbreviation('US')
if $usa.nil?
  $usa = Country.new(:name => 'United States', :abbreviation => 'US')
  $usa.save
end

$zip_code_lookup_failures = 0
$zip_code_lookup_successes = 0

def within_threshold_for_zips(lookup_success)
  if lookup_success
    $zip_code_lookup_successes += 1
  else
    $zip_code_lookup_failures += 1
  end
  true
end

def lookup_zip_codes(city_name, state_abbr)  
  sleep 1
  response = Net::HTTP.post_form(URI.parse('http://zip4.usps.com/zip4/zcl_1_results.jsp'), 
      {'city' => city_name.upcase, 'state' => state_abbr.upcase, 'visited' => '1', 'pagenumber' => '0'})

  doc = Hpricot(response.body)
  zip_codes = Array.new
  doc.search("//td[@class='main']").each do |element|
    zip_codes << element.inner_text.strip.match(/\d{5}/).to_s
  end
  unless within_threshold_for_zips(zip_codes.size > 0)
    puts "Too many zip code lookup failures... (#{$zip_code_lookup_failures})"
    exit
  end
  puts "Zip codes found for #{city_name}, #{state_abbr}: #{zip_codes.inspect}"
  return zip_codes
end

def persist(city_name, state_abbr, zip_codes, area_codes)
  state = StateProvince.find_by_abbreviation(state_abbr)
  if state.nil?
    state = StateProvince.new(:abbreviation => state_abbr, :name => STATE_ABBR[state_abbr], :country_id => $country.id)
    state.save
  end
  city = City.new(:name => city_name, :state_province_id => state.id)
  zip_codes.each do |zip|
    zip_code = PostalCode.find_by_postal_code(zip)
    if zip_code.nil?
      zip_code = PostalCode.new(:postal_code => zip)
      zip_code.save
    end
    city.postal_codes << zip_code
  end
  unless area_codes.nil?
    area_codes.each do |npa|
      area_code = PostalCode.find_by_postal_code(npa)
      if area_code.nil?
        area_code = PostalCode.new(:npa => npa)
        area_code.save
      end
      city.area_codes << area_code
    end
  end
  city.save
end

#    * Columns 1-2: United States Postal Service State Abbreviation
#    * Columns 3-4: State Federal Information Processing Standard (FIPS) code
#    * Columns 5-9: Place FIPS Code
#    * Columns 10-73: Name
#    * Columns 74-82: Total Population (2000)
#    * Columns 83-91: Total Housing Units (2000)
#    * Columns 92-105: Land Area (square meters) - Created for statistical purposes only.
#    * Columns 106-119: Water Area(square meters) - Created for statistical purposes only.
#    * Columns 120-131: Land Area (square miles) - Created for statistical purposes only.
#    * Columns 132-143: Water Area (square miles) - Created for statistical purposes only.
#    * Columns 144-153: Latitude (decimal degrees) First character is blank or "-" denoting North or South latitude respectively
#    * Columns 154-164: Longitude (decimal degrees) First character is blank or "-" denoting East or West longitude respectively 
def parse_places()
  File.open('places2k.txt') do |file|
    while line = file.gets do
      state_abbr = line[0,2]
#      state_fips_code = line[2,2]
#      place_fips_code = line[4,5]
      place_name = line[9,63].strip
      place_name.gsub!(/ (CDP|town|village|city)$/, '')
#      lookup_zip_codes(place_name, state_abbr).each do |zip|
#        puts "#{state_abbr}|#{place_name}|#{zip}"
#      end
      state = StateProvince.find_by_abbreviation(state_abbr)
      if state && City.find_by_name_and_state_province_id(place_name, state.id)
        puts "City #{place_name}, #{state_abbr} already exists... skipping"
        next
      end
      persist(place_name, state_abbr, lookup_zip_codes(place_name, state_abbr), nil)
    end
  end
end

parse_places