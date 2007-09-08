# load_fictional_characters.rb.rb
# July 26, 2007
#

my_dir = File.dirname(File.expand_path(__FILE__))
require my_dir + '/../models.rb'

Dir.glob('fictional_characters/*') do |file_name|
  File.open(file_name) do |file|
    while name = file.gets do
      fict_char = FictionalCharacter.new(:name => name)
      fict_char.save
    end
  end
end
