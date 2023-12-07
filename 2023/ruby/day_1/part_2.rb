input = File.read("input.txt").split

SPELLED_OUT = %w[one two three four five six seven eight nine].freeze

def convert(num)
  if num.match(/\d/)
    num
  else
    (SPELLED_OUT.index(num) + 1).to_s
  end
end

calibration_values = input.map.with_object([]) do |line, results|
  numbers = []
  matches = line.scan(/(?=(\d|#{SPELLED_OUT.join("|")}))/).flatten
  results << [convert(matches.first), convert(matches.last)].join.to_i
end

p calibration_values.compact.size
p calibration_values.compact.sum


