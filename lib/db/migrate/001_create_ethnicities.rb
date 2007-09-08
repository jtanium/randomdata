# 001_create_ethnicities.rb.rb
# July 19, 2007
#

class CreateEthnicities < ActiveRecord::Migration
  def self.up
    create_table :ethnicities, :force => true do |t|
      t.column :name, :string
    end
    add_index :ethnicities, :name, :unique => true
  end
  
  def self.down
    drop_table :ethnicities
  end
end

