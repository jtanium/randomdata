require 'rubygems'
require 'active_support/core_ext/string'
require 'sqlite3'

my_dir = File.dirname(File.expand_path(__FILE__))

db = SQLite3::Database.new( my_dir + '/../../db/database.sqlite' )
db.execute('PRAGMA synchronous = OFF;')

STDOUT.sync = true

# This is the format of the FedACHDir.txt file:
#
# Field                      | Len |  Position  Description
# ---------------------------+-----+----------+---------------------------------------------
# Routing Number             |  9  | 1-9      | The institution's routing number
# Office Code                |  1  | 10       | Main office or branch O=main B=branch
# Servicing FRB Number       |  9  | 11-19    | Servicing Fed's main office routing number
# Record Type Code           |  1  | 20       | The code indicating the ABA number to be used to route or send ACH items to the RFI
#                            |     |          |   0 = Institution is a Federal Reserve Bank
#                            |     |          |   1 = Send items to customer routing number
#                            |     |          |   2 = Send items to customer using new routing number field
# Change Date                |  6  | 21-26    | Date of last change to CRF information (MMDDYY)
# New Routing Number         |  9  | 27-35    | Institution's new routing number resulting from a merger or renumber
# Customer Name              |  36 | 36-71    | Commonly used abbreviated name
# Address                    |  36 | 72-107   | Delivery address
# City                       |  20 | 108-127  | City name in the delivery address
# State Code                 |  2  | 128-129  | State code of the state in the delivery address
# Zipcode                    |  5  | 130-134  | Zip code in the delivery address
# Zipcode Extension          |  4  | 135-138  | Zip code extension in the delivery address
# Telephone Area Code        |  3  | 139-141  | Area code of the CRF contact telephone number
# Telephone Prefix Number    |  3  | 142-144  | Prefix of the CRF contact telephone number
# Telephone Suffix Number    |  4  | 145-148  | Suffix of the CRF contact telephone number
# Institution Status Code    |  1  | 149      | Code is based on the customers receiver code (1=Receives Gov/Comm)
# Data View Code             |  1  | 150      | 1=Current view
# Filler                     |  5  | 151-155  | Spaces

open('FedACHdir.txt') do |file|
  while line = file.gets do
    routing_number = line[0..8]
    office_code = line[9]
    frb_number = line[10..18]
    record_type_code = line[19]
    change_date = line[20..25]
    new_routing_number = line[26..34]
    customer_name = line[35..70]
    address = line[71..106]
    city = line[107..126]
    state_abbr = line[127..128]
    zipcode = line[129..133]
    zipcode_ext = line[134..137]
    area_code = line[138..140]
    prefix = line[141..143]
    suffix = line[144..147]
    inst_status_code = line[149]
    sql = "INSERT INTO banks (fake, routing_number, office_code, servicing_frb_number, record_type_code, change_date, new_routing_number, name, address, city, state, zipcode, zipcode_ext, phone_number) VALUES (1, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
    args = [routing_number, office_code, frb_number, record_type_code, change_date, new_routing_number, customer_name.strip.titleize, address.strip.titleize, city.strip.titleize, state_abbr, zipcode, zipcode_ext, "#{area_code}-#{prefix}-#{suffix}"]
    db.execute(sql, args)
#    print '.'
    print "\r#{customer_name}"
  end
  puts
end