require "pry"

class OctopusManager
  attr_reader :octopuses, :flashes
  
  def initialize(octopuses)
    @octopuses = create_octopuses_hash(octopuses)
    @height = octopuses.size
    @width = octopuses[0].size
    @flashes = 0
  end

  def one_step!
    remaining = @octopuses.dup
    handled = {}
    remaining.each { |k, v| remaining[k] += 1 }
    step_flashes = 0

    while remaining.values.any? { _1 >= 10 }
      to_delete = []
      remaining.each do |k, v|
        if remaining[k] >= 10
          x, y = k
          handled[[x, y]] = 0
          to_delete << [x, y]
          @flashes += 1
          step_flashes += 1
          update_surroundings_octopuses(x, y, remaining)
        end
      end
      to_delete.each { remaining.delete(_1) }
    end
    @octopuses = remaining.merge(handled)
    step_flashes
  end

  def step!(steps)
    steps.times { one_step! }
  end

  def find_sync_time
    counter = 0
    loop do
      result = one_step!
      counter += 1
      break if result == @octopuses.size
    end
    counter
  end

  def update_surroundings_octopuses(x, y, remaining)
    surroundings_octopuses = [north(x, y, remaining), north_west(x, y, remaining), west(x, y, remaining),
                              south_west(x, y, remaining), south(x, y, remaining), south_east(x, y, remaining),
                              east(x, y, remaining), north_east(x, y, remaining)].compact

    surroundings_octopuses.each do |x_y_coord|
      remaining[[x_y_coord[0], x_y_coord[1]]] += 1
    end
  end

  private

    def create_octopuses_hash(octopuses)
      mapping = {}
      octopuses.each_with_index do |row, y_index|
        row.each_with_index do |energy, x_index|
          mapping[[x_index, y_index]] = energy
        end
      end
      mapping
    end

    def north(x, y, remaining)
      [x, y - 1] if remaining[[x, y - 1]]
    end

    def north_west(x, y, remaining)
      [x + 1, y - 1] if remaining[[x + 1, y - 1]]
    end

    def west(x, y, remaining)
      [x + 1, y] if remaining[[x + 1, y]]
    end

    def south_west(x, y, remaining)
      [x + 1, y + 1] if remaining[[x + 1, y + 1]]
    end

    def south(x, y, remaining)
      [x, y + 1] if remaining[[x, y + 1]]
    end

    def south_east(x, y, remaining)
      [x - 1, y + 1] if remaining[[x - 1, y + 1]]
    end

    def east(x, y, remaining)
      [x - 1, y] if remaining[[x - 1, y]]
    end

    def north_east(x, y, remaining)
      [x - 1, y - 1] if remaining[[x - 1, y - 1]]
    end
end

puzzle_data = File.read("../puzzle_data.txt").each_line.map { _1.chomp }.map { _1.split("") }.map { _1.map(&:to_i) }

om = OctopusManager.new(puzzle_data)

pp om.find_sync_time

