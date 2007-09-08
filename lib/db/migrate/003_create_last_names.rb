# 003_create_last_names.rb
# July 19, 2007
#

class CreateLastNames < ActiveRecord::Migration
  def self.up
    create_table :last_names, :force => true do |t|
      t.column :name, :string, :null => false
    end
    add_index :last_names, [:name], :unique => true

    create_table :last_names_ethnicities, :id => false, :force => true do |t|
      t.column :last_name_id, :integer, :null => false
      t.column :ethnicity_id, :integer, :null => false
    end
    add_index :last_names_ethnicities, [:last_name_id, :ethnicity_id], :unique => true
  end
  
  def self.down
    drop_table :last_names_ethnicities
    drop_table :last_names
  end
end
