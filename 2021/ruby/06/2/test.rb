require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "lantern_fish.rb"

TESTA_DATA = [3,4,3,1,2]

class LanternFishTest < Minitest::Test

  def setup
    @lf = LanternFish.new(TESTA_DATA)
  end

  def test_one_day_passed
    @lf.days_passed(1)
    assert_equal 5, @lf.population
  end

  def test_two_days_passed
    @lf.days_passed(2)
    assert_equal 6, @lf.population
  end

  def test_five_days_passed
    @lf.days_passed(5)
    assert_equal 10, @lf.population
  end

  def test_ten_days_passed
    @lf.days_passed(10)
    assert_equal 12, @lf.population
  end

  def test_eighteen_days_passed
    @lf.days_passed(18)
    assert_equal  26, @lf.population
  end

  def test_eighty_days_passed
    @lf.days_passed(80)
    assert_equal 5934, @lf.population
  end

  def test_days_passed_256_times
    @lf.days_passed(256)
    assert_equal 26984457539, @lf.population
  end
end