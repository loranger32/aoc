require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "octopus.rb"

TESTA_DATA = [[1, 1, 1, 1, 1],
              [1, 9, 9, 9, 1],
              [1, 9, 1, 9, 1],
              [1, 9, 9, 9, 1],
              [1, 1, 1, 1, 1]]

LARGER_TEST_DATA = [[5, 4, 8, 3, 1, 4, 3, 2, 2, 3],
                    [2, 7, 4, 5, 8, 5, 4, 7, 1, 1],
                    [5, 2, 6, 4, 5, 5, 6, 1, 7, 3],
                    [6, 1, 4, 1, 3, 3, 6, 1, 4, 6],
                    [6, 3, 5, 7, 3, 8, 5, 4, 7, 8],
                    [4, 1, 6, 7, 5, 2, 4, 6, 4, 5],
                    [2, 1, 7, 6, 8, 4, 1, 7, 2, 1],
                    [6, 8, 8, 2, 8, 8, 1, 1, 3, 4],
                    [4, 8, 4, 6, 8, 4, 8, 5, 5, 4],
                    [5, 2, 8, 3, 7, 5, 1, 5, 2, 6]]

STEP_ONE = [[3, 4, 5, 4, 3],
            [4, 0, 0, 0, 4],
            [5, 0, 0, 0, 5],
            [4, 0, 0, 0, 4],
            [3, 4, 5, 4, 3]]

STEP_TWO = [[4, 5, 6, 5, 4],
            [5, 1, 1, 1, 5],
            [6, 1, 1, 1, 6],
            [5, 1, 1, 1, 5],
            [4, 5, 6, 5, 4]]

class OctopusSimpleTest < Minitest::Test
  def setup
    @om = OctopusManager.new(TESTA_DATA)
  end

  def test_one_step
    @om.one_step!
    assert_equal 9, @om.flashes
  end

  def test_two_steps
    @om.step!(2)
    assert_equal 9, @om.flashes
  end
end

class OctopusLargerTest < Minitest::Test
  def setup
    @om = OctopusManager.new(LARGER_TEST_DATA)
  end

  def test_ten_steps
    @om.step!(10)
    assert_equal 204, @om.flashes
  end

  def test_hundred_times
    @om.step!(100)
    assert_equal 1656, @om.flashes
  end
end
