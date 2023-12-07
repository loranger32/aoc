input = File.read("input.txt").split

calibration_values = input.map.with_object([]) do |line, results|
  matching_numbers = line.scan(/\d/)
  results << [matching_numbers.first, matching_numbers.last].join("").to_i
end

p calibration_values.sum
