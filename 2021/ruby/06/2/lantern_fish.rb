require "pry"

class LanternFish
  CYCLE_LENGTH = 9

  attr_reader :matrix

  def initialize(fishes)
    @matrix = create_cycle_matrix(fishes)
  end

  def days_passed(days)
    days.times do
      ready = @matrix.shift
      @matrix << ready
      @matrix[6] += ready
    end
  end

  def population
    @matrix.reduce(:+)
  end

  private

    def create_cycle_matrix(fishes)
      cycle = Array.new(CYCLE_LENGTH, 0)
      fishes.each { |fish_age| cycle[fish_age] += 1 }
      cycle
    end
end

fishes = File.read("../puzzle_data.txt").split(",").map(&:to_i)
lf = LanternFish.new(fishes)
lf.days_passed(256)
p lf.population