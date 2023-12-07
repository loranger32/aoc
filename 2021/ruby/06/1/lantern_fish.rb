require "pry"

class LanternFish
  attr_reader :fishes

  def initialize(fishes)
    @fishes = fishes
  end

  def one_more_day!
    new_fishes = 0

    @fishes = fishes.map do |fish|
      if fish == 0
        new_fishes += 1
        6
      else
        fish - 1
      end
    end

    new_fishes.times { @fishes << 8 }
  end

  def days_passed(days)
    days.times { |_| one_more_day! }
  end
end


fishes = File.read("../test_data.txt").split(",").map(&:to_i)

lf = LanternFish.new(fishes)
lf.days_passed(175)
p lf.fishes.size