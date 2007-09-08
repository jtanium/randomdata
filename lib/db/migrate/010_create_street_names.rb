# 010_create_street_names.rb
# July 26, 2007
#

class CreateStreetNames < ActiveRecord::Migration
  def self.up
    create_table :street_names, :force => true do |t|
      t.column :name, :string, :null => false
    end
    add_index :street_names, [:name], :unique => true
  end
  
  def self.down
    drop_table :street_names
  end
end
