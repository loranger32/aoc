require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "lantern_fish.rb"

TESTA_DATA = [3,4,3,1,2]

class LanternFishTest < Minitest::Test
  def setup
    @lf = LanternFish.new(TESTA_DATA)
  end

  def test_has_a_fishes_method
    assert_equal @lf.fishes, TESTA_DATA
  end

  def test_one_more_day_once
    @lf.one_more_day!
    assert_equal [2, 3, 2, 0, 1], @lf.fishes
  end

  def test_one_more_day_twice
    @lf.one_more_day!
    @lf.one_more_day!
    assert_equal [1, 2, 1, 6, 0, 8], @lf.fishes
  end

  def test_days_passed_five_times
    @lf.days_passed(5)
    assert_equal [5, 6, 5, 3, 4, 5, 6, 7, 7, 8], @lf.fishes
  end

  def test_days_passed_ten_times
    @lf.days_passed(10)
    assert_equal [0, 1, 0, 5, 6, 0, 1, 2, 2, 3, 7, 8], @lf.fishes
  end

  def test_days_passed_eighteen_times
    @lf.days_passed(18)
    assert_equal [6, 0, 6, 4, 5, 6, 0, 1, 1, 2, 6, 0,
      1, 1, 1, 2, 2, 3, 3, 4, 6, 7, 8, 8, 8, 8], @lf.fishes
  end

  def test_days_passed_eighty_times
    @lf.days_passed(80)
    assert_equal 5934, @lf.fishes.size
  end

  def test_days_passed_256_times
    @lf.days_passed(256)
    assert_equal 26984457539, @lf.fishes.size
  end
end