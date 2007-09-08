# 009_create_postal_codes.rb
# July 19, 2007
#

class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes, :force => true do |t|
      t.column :postal_code, :string, :null => false
    end
    add_index :postal_codes, [:postal_code], :unique => true

    create_table :cities_postal_codes, :id => false, :force => true do |t|
      t.column :city_id, :integer, :null => false
      t.column :postal_code_id, :integer, :null => false
    end
    add_index :cities_postal_codes, [:city_id, :postal_code_id], :unique => true
  end
  
  def self.down
    drop_table :cities_postal_codes
    drop_table :postal_codes
  end
end
