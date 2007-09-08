my_dir = File.dirname(File.expand_path(__FILE__))
require my_dir + '/../../random_data.rb'
require my_dir + '/../../models.rb'

PREFIXES = ['Bank of']

SUFFIXES = ['Bank', 'Credit Union', 'Savings', 'Savings & Loan', 'Bank and Trust']

DIRECTIONS = ['Northern', 'Eastern', 'Southern', 'Western', 'Northeastern', 'Northwestern', 'Southeastern', 'Northeastern']

NOUNS = ['Community', 'Neighborhood', 'State', 'City', 'County', 'Regional', 'Global', 'International', 'Nationwide', 'National', 'Citizens', 'Americans', 'Californians', 'Coloradans', 'Floridians', 'Illinoisans', 'Iowans', 'Montanans', 'North Carolinians', 'Ohioans', 'Oregonians', 'South Carolinians', 'Tennesseeans', 'Texans', 'Utahns', 'Washingtonians', 'Rural', 'Midland', 'Inland', 'Pacific', 'Atlantic', 'Caribbean', 'Palladium', 'Platinum', 'Gold', 'Silver', 'Aluminum', 'Plutonium', 'Uranium', 'Unity', 'Royalty', 'Heritage']

PLACES = ['Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware', 'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico', 'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming']

ORDINAL_NUMBERS = ['First', 'Second', 'Third', 'Fourth', 'Fifth', 'Sixth', 'Seventh', 'Eighth', 'Ninth', 'Tenth']

puts "Generating bank names...\n"
$bank_count = 0

def gen_bank(arr1, arr2, arr3=nil, arr4=nil)
  bank_name = ''
  arr1.each do |ele1|
    arr2.each do |ele2|
      if arr3.nil?
        create_bank("#{ele1} #{ele2}")
      else
        arr3.each do |ele3|
          if arr4.nil?
            create_bank("#{ele1} #{ele2} #{ele3}")
          else
            arr4.each do |ele4|
              create_bank("#{ele1} #{ele2} #{ele3} #{ele4}")
            end # eo-arr4.each
          end # eo-arr4.nil?
        end # eo-arr3.each
      end # eo-arr3.nil?
    end # eo-arr2.each
  end # eo-arr1.each
end #eo-gen_bank()

def create_bank(bank_name)
  return if Bank.find_by_name(bank_name)
  address = generate_random_address
  bank = Bank.new({:fake => true,
    :routing_number => "5#{rand(100000000)}",
    :name => bank_name,
    :address => address[:street_address],
    :city => address[:city],
    :state => address[:state_province],
    :zipcode => address[:postal_code],
    :phone_number => address[:phone_number]})
  if bank.valid?
    puts "\n\n============================"
    # puts bank_name
    # puts address.inspect
    puts bank.inspect
    puts "============================"
    begin
      bank.save
    rescue Error => e
      puts "Oh well... #{e}"
      return
    end
    $bank_count += 1
  else
    while bank.errors.invalid?(:routing_number)
      bank.routing_number = "5#{rand(100000000)}"
      if bank.valid?
        puts "\n============================"
        # puts bank_name
        # puts address.inspect
        puts bank.inspect
        puts "============================\n\n"
        begin
          bank.save
        rescue Error => e
          puts "Oh well... #{e}"
          return
        end
        $bank_count += 1
        return
      end
    end
  end
end

gen_bank(PREFIXES, DIRECTIONS, NOUNS) # e.g. 'Bank of Northern Community'
gen_bank(PREFIXES, DIRECTIONS, PLACES) # e.g. 'Bank of Northern Alabama'
gen_bank(PREFIXES, NOUNS) # e.g. 'Bank of Community'
gen_bank(PREFIXES, PLACES) # e.g. 'Bank of Alabama'
gen_bank(PREFIXES, ORDINAL_NUMBERS, NOUNS) # e.g. 'Bank of First Community'
gen_bank(PREFIXES, ORDINAL_NUMBERS, DIRECTIONS) # e.g. 'Bank of First Northern'

gen_bank(DIRECTIONS, PREFIXES, NOUNS) # e.g. 'Northern Bank of Community'
gen_bank(DIRECTIONS, PREFIXES, PLACES) # e.g. 'Northern Bank of Alabama'
gen_bank(DIRECTIONS, SUFFIXES) # e.g. 'Northern Bank'
gen_bank(DIRECTIONS, NOUNS, SUFFIXES) # e.g. 'Northern Community Bank'
gen_bank(DIRECTIONS, PLACES, SUFFIXES) # e.g. 'Northern Alabama Bank'
gen_bank(DIRECTIONS, PLACES, NOUNS, SUFFIXES) # e.g. 'Northern Alabama Community Bank'
gen_bank(DIRECTIONS, ORDINAL_NUMBERS, SUFFIXES) # e.g. 'Northern First Bank'
gen_bank(DIRECTIONS, ORDINAL_NUMBERS, NOUNS, SUFFIXES) # e.g. 'Northern First Community Bank'

gen_bank(NOUNS, SUFFIXES) # e.g. 'Community Bank'
gen_bank(NOUNS, DIRECTIONS, SUFFIXES) # e.g. 'Community Northern Bank'
gen_bank(NOUNS, ORDINAL_NUMBERS, SUFFIXES) # e.g. 'Community First Bank'

gen_bank(PLACES, NOUNS, SUFFIXES) # e.g. 'Alabama Community Bank'

gen_bank(ORDINAL_NUMBERS, PREFIXES, PLACES) # e.g. 'First Bank of Alabama'
gen_bank(ORDINAL_NUMBERS, PREFIXES, DIRECTIONS, PLACES) # e.g. 'First Bank of Northern Alabama'
gen_bank(ORDINAL_NUMBERS, PREFIXES, NOUNS) # e.g. 'First Bank of Community'
gen_bank(ORDINAL_NUMBERS, DIRECTIONS, PREFIXES, PLACES) # e.g. 'First Northern Bank of Alabama'
gen_bank(ORDINAL_NUMBERS, DIRECTIONS, SUFFIXES) # e.g. 'First Northern Bank'
gen_bank(ORDINAL_NUMBERS, DIRECTIONS, NOUNS, SUFFIXES) # e.g. 'First Northern Community Bank'
gen_bank(ORDINAL_NUMBERS, DIRECTIONS, PLACES, SUFFIXES) # e.g. 'First Northern Alabama Bank'
gen_bank(ORDINAL_NUMBERS, NOUNS, SUFFIXES) # e.g. 'First Community Bank'

puts "\nbank_count: #{$bank_count}"