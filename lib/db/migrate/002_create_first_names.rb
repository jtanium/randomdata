# 002_create_first_names.rb
# July 19, 2007
#

class CreateFirstNames < ActiveRecord::Migration
  def self.up
    create_table :first_names, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :gender, :string
    end
    add_index :first_names, [:name, :gender], :unique => true
    add_index :first_names, [:name]
    add_index :first_names, [:gender]

    create_table :first_names_ethnicities, :id => false, :force => true do |t|
      t.column :first_name_id, :integer, :null => false
      t.column :ethnicity_id, :integer, :null => false
    end
    add_index :first_names_ethnicities, [:first_name_id, :ethnicity_id], :unique => true
  end
  
  def self.down
    drop_table :first_names_ethnicities
    drop_table :first_names
  end
end
