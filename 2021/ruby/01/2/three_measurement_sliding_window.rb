depths = []
depth_increases = 0

File.read("input.txt").each_line { depths << _1.chomp.to_i }

windows_sums = depths.map.with_index do |depth, index|
  next_depth = depths[index + 1]
  second_next_depth = depths[index + 2]

  next if next_depth.nil? || second_next_depth.nil?

  [depth, next_depth, second_next_depth].reduce(:+)
end

windows_sums.compact!

windows_sums.each_with_index do |depth, index|
  next_depth = windows_sums[index + 1]
  next if next_depth.nil?
  depth_increases += 1 if next_depth > depth
end

p depth_increases