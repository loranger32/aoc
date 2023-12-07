require "pry"

class CaveSquare
  attr_reader :x, :y, :depth, :risk

  def initialize(x, y, depth)
    @x = x
    @y = y
    @depth = depth
    @risk = @depth + 1
  end

  def above(others)
    others.select { |other| other.x == x && other.y == y - 1 }.first
  end

  def below(others)
    others.select { |other| other.x == x && other.y == y + 1 }.first
  end

  def left(others)
    others.select { |other| other.x == x - 1 && other.y == y }.first
  end

  def right(others)
    others.select { |other| other.x == x + 1 && other.y == y }.first
  end
end

class Cave
  attr_reader :mapping, :squares

  def initialize(mapping)
    @mapping = mapping
    @squares = create_squares
  end

  def lowest_squares
    @squares.each_with_object([]) do |square, result|
      result << square if surrounding_squares(square).all? { _1.depth > square.depth }
    end
  end

  def surrounding_squares(square)
    [square.above(@squares), square.below(@squares), square.right(@squares), square.left(@squares)].compact
  end

    private

    def create_squares
      result = []
      mapping.each_with_index do |row, y_index|
        row.each_with_index do |square_depth, x_index|
          result << CaveSquare.new(x_index, y_index, square_depth)
        end
      end
      result
    end
end


puzzle_data = File.read("../puzzle_data.txt").each_line.map(&:chomp).map { _1.split("").map(&:to_i) }
cave = Cave.new(puzzle_data)
pp cave.lowest_squares.map(&:risk).reduce(&:+)




