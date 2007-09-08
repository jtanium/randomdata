# 004_create_fictional_characters.rb
# July 19, 2007
#

class CreateFictionalCharacters < ActiveRecord::Migration
  def self.up
    create_table :fictional_characters, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :gender, :string
    end
    add_index :fictional_characters, [:name], :unique => true
  end
  
  def self.down
    drop_table :fictional_characters
  end
end
