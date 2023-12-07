orders = []

depth = 0
distance = 0

File.read("input.txt").each_line { orders << _1.chomp }

orders.map! { _1.split(" ") }

orders.each do |order|
  case order[0]
  when "up" then depth += order[1].to_i
  when "down" then depth -= order[1].to_i
  when "forward" then distance += order[1].to_i
  else raise StandardError, "oops"
  end
end

p depth
p distance

p (depth * distance).abs