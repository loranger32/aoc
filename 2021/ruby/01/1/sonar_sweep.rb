depths = []
depth_increases = 0

File.read("input.txt").each_line { depths << _1.chomp.to_i }

depths.each_with_index do
  next if depths[_2 + 1].nil?
  depth_increases += 1 if depths[_2 + 1] > _1
end

p depth_increases
