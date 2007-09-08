# models.rb
# July 19, 2007
#

require 'rubygems'
require 'active_record'
require File.dirname(File.expand_path(__FILE__)) + '/database_config.rb'

ActiveRecord::Base.establish_connection(DatabaseConfig.as_hash)
ActiveRecord::Base.logger = Logger.new(STDERR)

class Ethnicity < ActiveRecord::Base
  has_and_belongs_to_many :first_names
  has_and_belongs_to_many :last_names
  validates_presence_of :name
  validates_uniqueness_of :name
end

class FirstName < ActiveRecord::Base
  has_and_belongs_to_many :ethnicities
  validates_presence_of :name
  validates_uniqueness_of :name
end

class LastName < ActiveRecord::Base
  has_and_belongs_to_many :ethnicities  
  validates_presence_of :name
  validates_uniqueness_of :name
end

class FictionalCharacter < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
end

class Country < ActiveRecord::Base
  has_many :state_provinces
  validates_presence_of :name
  validates_uniqueness_of :name
end

class StateProvince < ActiveRecord::Base
  belongs_to :country
  has_many :cities
  validates_presence_of :name
  validates_uniqueness_of :name
end

class City < ActiveRecord::Base
  belongs_to :state_province
  has_and_belongs_to_many :area_codes
  has_and_belongs_to_many :postal_codes
  validates_presence_of :name
end

class AreaCode < ActiveRecord::Base
  has_and_belongs_to_many :cities
  validates_uniqueness_of :npa
  validates_presence_of :npa
end

class PostalCode < ActiveRecord::Base
  has_and_belongs_to_many :cities
  validates_uniqueness_of :postal_code
  validates_presence_of :postal_code
end

class StreetName < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
end

class Bank < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_uniqueness_of :routing_number
  validates_format_of :routing_number, :with => /\d{9}/
end
