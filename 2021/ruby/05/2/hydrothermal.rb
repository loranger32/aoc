require "dead_end"
require "pry"

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def to_s
    "X: #{x}, Y: #{y}"
  end
end

class Vector
  attr_reader :point1, :point2

  def initialize(point1, point2)
    @point1 = point1
    @point2 = point2
  end

  def deserialize
    "#{point1.x},#{point1.y} -> #{point2.x},#{point2.y}\n"
  end

  def to_s
    point1.to_s + " -> " + point2.to_s
  end

  def spots_covered
    covered = []

    # Verticals
    if point1.x == point2.x
      ([point1.y, point2.y].min..[point1.y, point2.y].max).each { covered << Point.new(point1.x, _1).to_s }
    # Horizontals
    elsif point1.y == point2.y
      ([point1.x, point2.x].min..[point1.x, point2.x].max).each { covered << Point.new(_1, point1.y).to_s }
    # Diagonals
    else
      starting_point, ending_point = [point1, point2].minmax { |a, b| a.x <=> b.x }

      (starting_point.x..ending_point.x).each_with_index do |x_value, index|
        if starting_point.y < ending_point.y
          covered << Point.new(x_value, starting_point.y + index).to_s
        else
          covered << Point.new(x_value, starting_point.y - index).to_s
        end
      end
    end
    covered
  end
end

puzzle_data = []
File.read("../puzzle_data.txt").each_line { puzzle_data << _1.chomp.split(" -> ").map { |point| point.split(",").map(&:to_i) } }

puzzle_data = puzzle_data.map do |vectors|
  vectors.map do |coordinates|
    Point.new(coordinates[0], coordinates[1])
  end
end

vectors = puzzle_data.map do |vector|
  Vector.new(vector[0], vector[1])
end


p vectors.map(&:spots_covered).compact.flatten.tally.values.count { _1 > 1 }