# 007_create_cities.rb
# July 19, 2007
#

class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities, :force => true do |t|
      t.column :state_province_id, :integer, :null => false
      t.column :name, :string, :null => false
    end
    add_index :cities, [:state_province_id, :name], :unique => true
    add_index :cities, [:name]
end
  
  def self.down
    drop_table :cities
  end
end
