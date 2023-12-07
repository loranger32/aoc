require "to_decimal"

base2 = ToDecimal::Base2

def retrieve_bits(numbers, index)
  numbers.each
end

def select_highest(hash)
  if hash["0"].nil? && hash["1"].nil?
    raise StandardError, "Oops"
  elsif hash["0"].nil?
    "1"
  elsif hash["1"].nil?
    "0"
  else
    hash["0"] > hash["1"] ? "0" : "1"
  end
end

def select_lowest(hash)
  if hash["0"].nil? && hash["1"].nil?
    raise StandardError, "Oops"
  elsif hash["0"].nil?
    "1"
  elsif hash["1"].nil?
    "0"
  else
    hash["0"] > hash["1"] ? "1" : "0"
  end
end

numbers = File.read("input.txt").each_line.with_object([]) { _2 << _1.chomp }

oxygen_numbers = numbers.dup
co2_numbers = numbers.dup

12.times do |i|
  most_common_bit = select_highest(oxygen_numbers.map { _1[i] }.tally)

  oxygen_numbers = oxygen_numbers.select { _1[i] == most_common_bit }
  break if oxygen_numbers.size == 1
end

oxygen = base2[oxygen_numbers.first]


12.times do |i|
  least_common_bit = select_lowest(co2_numbers.map { _1[i] }.tally)

  co2_numbers = co2_numbers.select { _1[i] == least_common_bit }
  break if co2_numbers.size == 1
end

co2 = base2[co2_numbers.first]

p oxygen * co2


