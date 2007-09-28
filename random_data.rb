# random_data.rb
# July 26, 2007
#
my_dir = File.dirname(File.expand_path(__FILE__))

require my_dir + '/models.rb'
#
# hash keys:
#   :first_name
#   :middle_name
#   :last_name
#   :gender
#   :email_address
#   :username
#   :password
#   :date_of_birth (YYYY-MM-DD), aged between 18 and 65
#   :mothers_maiden_name
#   :social_security_number
#   :mailing_street_address
#   :mailing_city
#   :mailing_state
#   :mailing_postal_code
#   :mailing_country
#   :billing_street_address
#   :billing_city
#   :billing_state
#   :billing_postal_code
#   :billing_country
#   :daytime_phone_number
#   :evening_phone_number
#   :mobile_phone_number
#   :pager_number
#   :credit_card_type
#   :credit_card_number
#   :credit_card_expiration_date
#   :credit_card_cvv
#   :bank_routing_number
#   :bank_account_number
#   :bank_name
#   :bank_street_address
#   :bank_city
#   :bank_state
#   :bank_zipcode
#
def generate_identity(options)
  identity = Hash.new
  name = generate_random_name
  identity[:date_of_birth] = (1 + rand(12)).to_s
  identity[:first_name] = name[:first_name]
  identity[:middle_name] = name[:middle_name]
  identity[:last_name] = name[:last_name]
  identity[:gender] = name[:gender]
  identity[:mothers_maiden_name] = random_model(LastName).name
  identity[:social_security_number] = rand(999).to_s.rjust(3, '0') + '-' + rand(999).to_s.rjust(3, '0') + '-' + rand(999).to_s.rjust(4, '0')
  identity[:username] = name[:first_name] + name[:last_name] + rand(999).to_s
  identity[:password] = 'password'
  return identity
end

def generate_bank(options)
  bank = random_model(Bank)
  if bank.is_real
  else
  end
end

def generate_random_date_of_birth()
  months_and_days = [
    [1..31], # Jan
    [1..28], # Feb
    [1..31], # Mar
    [1..30], # Apr
    [1..31], # May
    [1..30], # Jun
    [1..31], # Jul
    [1..31], # Aug
    [1..30], # Sep
    [1..31], # Oct
    [1..30], # Nov
    [1..31]  # Dec
  ]
  age = 18 + rand(48) # => a number between 18 and 65
  birth_year = Time.now.year - age
  month_index = rand()
  birth_month = (1 + month_index).to_s.rjust(2, '0')
  days = months_and_days[month_index]
  birth_day = days[rand(days.length)].to_s.rjust(2, '0')
  return birth_year + '-' + birth_month + '-' + birth_day
end

def generate_random_name()
  data = Hash.new
  data[:last_name] = random_model(LastName).name
  first_name_obj = random_first_name
  data[:gender] = first_name_obj.gender
  data[:first_name] = first_name_obj.name
  data[:middle_name] = random_first_name(first_name_obj.gender).name
  return data
end

#
# options:
#   :country - ...
#   :city - the name of the city the address should be located in
#   :state_province - the name of the state the address should be located in
#   :state_abbr - the abbreviation of the state the address should be located in
#   :area_code - the area code the address should be located in
#
def generate_random_address(options=nil)
  if !options.nil?
    state_name = options[:state_province]
    city_name = options[:city]
    state_abbr = options[:state_abbr]
    area_code = options[:area_code]
  end
  address_hash = Hash.new
  # TODO: do options...
  city = random_model(City)
  address_hash[:street_address] = rand(10000).to_s + ' ' + random_model(StreetName).name
  address_hash[:city] = city.name
  address_hash[:state_province] = city.state_province.name
  address_hash[:phone_number] = pick_area_code(city).npa + '-' + rand(1000).to_s + '-' + rand(10000).to_s
  address_hash[:postal_code] = pick_postal_code(city).postal_code
  return address_hash
end

def generate_random_credit_card
  data = Hash.new
  # +============+=============+===============+
  # | Card Type  | Begins With | Number Length |
  # +============+=============+===============+
  # | AMEX       | 34 or 37    | 15            |
  # +------------+-------------+---------------+
  # | Discover   | 6011        | 16            |
  # +------------+-------------+---------------+
  # | MasterCard | 51-55       | 16            |
  # +------------+-------------+---------------+
  # | Visa       | 4           | 13 or 16      |
  # +------------+-------------+---------------+
  case rand(4)
    when 0
      data[:credit_card_type] = 'American Express'
      data[:credit_card_number] = random_amex_num
      data[:credit_card_cvv] = rand(9999).to_s.rjust(4,'0')
    when 1
      data[:credit_card_type] = 'Discover'
      data[:credit_card_number] = random_disc_num
      data[:credit_card_cvv] = rand(999).to_s.rjust(3,'0')
    when 2
      data[:credit_card_type] = 'MasterCard'
      data[:credit_card_number] = random_mc_num
      data[:credit_card_cvv] = rand(999).to_s.rjust(3,'0')
    when 3
      data[:credit_card_type] = 'Visa'
      data[:credit_card_number] = random_visa_num
      data[:credit_card_cvv] = rand(999).to_s.rjust(3,'0')
  end
  data[:credit_card_expiration_date] = (rand(12) + 1).to_s.rjust(2, '0') + '/' + (rand(7) + 1 + Time.now.year).to_s
  return data
end

private

def random_first_name(gender = nil)
  if gender.nil?
    return random_model(FirstName)
  end
  names = FirstName.find(:all, ['gender = :gender', {:gender => gender}])
  return FirstName.find_by_id(rand(names.size))
end

def random_model(model_class)
  max = model_class.maximum(:id)
  model_obj = nil
  while model_obj.nil? do
    model_obj = model_class.find_by_id(rand(max + 1))
  end
  return model_obj
end

def pick_area_code(city)
  area_codes = city.area_codes
  area_codes_length = area_codes.length
  puts "area_codes_length: #{area_codes_length}"
  
  return area_codes[0] if area_codes_length.eql? 1
  
  area_code_obj = area_codes[rand(area_codes.length + 1)]
  puts "Picked area_code: #{area_code_obj.inspect}"
  return area_code_obj
end

def pick_postal_code(city)
  postal_codes = city.postal_codes
  postal_codes_length = postal_codes.length
  return postal_codes[0] if postal_codes_length.eql? 1
  return postal_codes[rand(postal_codes_length + 1)]
end

def random_amex_num
  prefixes = ['34', '37']
  while !valid_luhn?(cc_num = prefixes[rand(2)] + rand(10000000000000).to_s.rjust(13, '0')) do; end
  return cc_num
end

def random_disc_num
  while !valid_luhn?(cc_num = '6011' + rand(1000000000000).to_s.rjust(12, '0')) do; end
  return cc_num
end

def random_mc_num
  while !valid_luhn?(cc_num = '5' + (rand(5) + 1).to_s + rand(100000000000000).to_s.rjust(14, '0')) do; end
  return cc_num
end

def random_visa_num
  while !valid_luhn?(cc_num = '4' + rand(1000000000000000).to_s.rjust(15, '0')) do; end
  return cc_num
end

def valid_luhn?(cc_number)
  cc_number = cc_number.gsub(/\D/,'').split(//).collect { |digit| digit.to_i }
  parity = cc_number.length % 2
  sum = 0
  
  cc_number.each_with_index do |digit,index|
    digit = digit * 2 if index % 2 == parity
    digit = digit - 9 if digit > 9
    sum = sum + digit
  end

  return (sum % 10) == 0
end