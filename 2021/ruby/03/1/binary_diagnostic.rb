require "to_decimal"

base2 = ToDecimal::Base2

def select_highest(hash)
  hash["0"] > hash["1"] ? "0" : "1"
end

def select_lowest(hash)
  select_highest(hash) == "0" ? "1" : "0"
end

numbers = File.read("input.txt").each_line.with_object([]) { _2 << _1.chomp }

results = []
12.times { results[_1] = [] }

numbers.each do |number|
  12.times { results[_1] << number[_1] }
end

frequences = results.map(&:tally)

gamma = frequences.map { select_highest(_1) }.join
epsilon = frequences.map { select_lowest(_1) }.join

p base2[gamma] * base2[epsilon]
