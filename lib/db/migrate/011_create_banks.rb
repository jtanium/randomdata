# 011_create_banks.rb
# July 26, 2007
#

class CreateBanks < ActiveRecord::Migration
  def self.up
    create_table :banks, :force => true do |t|
      t.column :fake, :boolean, :null => false
      t.column :routing_number, :string, :null => false, :limit => 9
      t.column :office_code, :string, :limit => 1
      t.column :servicing_frb_number, :string, :limit => 9
      t.column :record_type_code, :string, :limit => 1
      t.column :change_date, :timestamp
      t.column :new_routing_number, :string, :limit => 9
      t.column :name, :string, :limit => 36, :null => false
      t.column :address, :string, :limit => 36
      t.column :city, :string, :limit => 20
      t.column :state, :string, :limit => 2
      t.column :zipcode, :string, :limit => 5
      t.column :zipcode_ext, :string, :limit => 4
      t.column :phone_number, :string, :limit => 12
    end
    add_index :banks, [:name]
    add_index :banks, [:routing_number], :unique => true
  end
  
  def self.down
    drop_table :banks
  end
end
