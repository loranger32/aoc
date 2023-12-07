orders = []

depth = 0
aim = 0
distance = 0

File.read("input.txt").each_line { orders << _1.chomp }

orders.map! { _1.split(" ") }

orders.each do |order|
  case order[0]
  when "up" then aim -= order[1].to_i
  when "down" then aim += order[1].to_i
  when "forward"
    distance += order[1].to_i
    depth += aim * order[1].to_i
  else raise StandardError, "Oops"
  end
end

p aim
p depth
p distance

p (depth * distance).abs