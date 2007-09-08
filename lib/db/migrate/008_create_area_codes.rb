# 008_create_area_codes.rb
# July 19, 2007
#

class CreateAreaCodes < ActiveRecord::Migration
  def self.up
    create_table :area_codes, :force => true do |t|
      t.column :npa, :string, :null => false
    end
    add_index :area_codes, [:npa], :unique => true

    create_table :area_codes_cities, :id => false, :force => true do |t|
      t.column :city_id, :integer, :null => false
      t.column :area_code_id, :integer, :null => false
    end
    add_index :area_codes_cities, [:city_id, :area_code_id], :unique => true
  end
  
  def self.down
    drop_table :area_codes_cities
    drop_table :area_codes
  end
end
