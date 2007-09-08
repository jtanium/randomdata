require 'random_data'

for i in 0..50
  puts generate_random_name.to_yaml
  puts generate_random_address.to_yaml
end
