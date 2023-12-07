require "pry"
# 367 too low
class CrabOptimizer
  attr_reader :positions, :mean_value

  def initialize(crabs)
    @positions = crabs
    @mean_value = positions.reduce(:+) / crabs.size
    @max_value = @positions.max
    @min_value = @positions.min
    @consumptions = {}
  end

  def optimize
    optimized_fuel = fuel_to(@mean_value)
    if fuel_to(@mean_value + 1) < fuel_to(@mean_value - 1)  
      @mean_value.upto(@max_value) do |increasing_value|
        new_guess = fuel_to(increasing_value)
        if optimized_fuel < new_guess
          return optimized_fuel
        else
          optimized_fuel = new_guess
        end
      end
    else
      @mean_value.downto(@min_value) do |decreasing_value|
        new_guess = fuel_to(decreasing_value)
        if optimized_fuel < new_guess
          return optimized_fuel
        else
          optimized_fuel = new_guess
        end
      end
    end
  end

  def fuel_to(value)
    fuel = 0
    @positions.each do |position|
      if position >= value
        fuel += (position - value)
      else position < value
        fuel += (value - position)
      end
    end
    fuel
  end
end



puzzle_data = File.read("../puzzle_data.txt").split(",").map(&:to_i)

co = CrabOptimizer.new(puzzle_data)

p co.optimize
# puts "down :"
# p co.fuel_to(co.mean_value - 1)
# p co.fuel_to(co.mean_value - 2)
# p co.fuel_to(co.mean_value - 3)
# p co.fuel_to(co.mean_value - 4)

# puts "up"
# p co.fuel_to(co.mean_value + 1)
# p co.fuel_to(co.mean_value + 2)
# p co.fuel_to(co.mean_value + 3)
# p co.fuel_to(co.mean_value + 4)
# p co.fuel_to(co.mean_value + 5)
