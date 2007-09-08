def log(s)
  puts "[valid_luhn?] #{s}"
end

def valid_luhn?(cc_num)
  log "cc_num: #{cc_num}"
  cc_num.gsub!(/\D/, '') # remove non-digit characters...
  log "cc_num: #{cc_num}"
  cc_num.reverse!
  log "cc_num: #{cc_num}"
  parity = cc_num.length
  digits = Array.new
  i = 0
  sum = 0
  cc_num.scan(/./) do |digit|
    puts "\n\n"
    log "digit: #{digit}"
    if i % 2 == parity
      digit = (digit.to_i * 2).to_s
    end
    log "digit: #{digit}"
    digits.unshift(digit)
    i += 1
  end
  log "digits: #{digits.inspect}"
  false
end

puts valid_luhn?('4408 0412 3456 7893')