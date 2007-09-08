# 005_create_countries.rb
# July 19, 2007
#

class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries, :force => true do |t|
      t.column :name, :string
      t.column :abbreviation, :string, :limit => 2
    end
    add_index :countries, [:name], :unique => true
    execute 'insert into countries (name, abbreviation) values (\'United States\', \'US\')'
  end
  
  def self.down
    drop_table :countries
  end
end
