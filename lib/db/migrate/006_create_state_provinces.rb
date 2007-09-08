# 006_create_state_provinces.rb
# July 19, 2007
#

class CreateStateProvinces < ActiveRecord::Migration
  def self.up
    create_table :state_provinces, :force => true do |t|
      t.column :country_id, :integer, :null => false
      t.column :name, :string
      t.column :abbreviation, :string, :null => false
    end
    add_index :state_provinces, [:country_id, :name], :unique => true
  end
  
  def self.down
    drop_table :state_provinces
  end
end
