require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

require_relative "crabs.rb"

TEST_DATA = [16,1,2,0,4,2,7,1,2,14]

class CrabOptimizerTest < Minitest::Test

  def setup
    @co = CrabOptimizer.new(TEST_DATA) 
  end

  def test_optimize_gives_correct_output
    assert_equal 2, @co.optimize
  end
end