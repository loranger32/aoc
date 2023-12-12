require "pry"

INPUT = "input.txt"
TEST_INPUT = "test_input.txt"

input = File.read(INPUT).split("\n")
                        .map { _1.sub(/Game \d{1,3}: /, "") }
                        .map { _1.delete(",;:") }
                        .map(&:split)

class Pick
  include Comparable

  attr_reader :qty, :color

  def initialize(qty, color)
    @color = color
    @qty = qty
  end

  def possible?
    case color
    when "red" then self <= RED_LIMIT
    when "green" then self <= GREEN_LIMIT
    when "blue" then self <= BLUE_LIMIT
    end
  end

  def <=>(other)
    raise StandardError, "Wrong comparison" unless color == other.color
    qty <=> other.qty
  end
end

# Part 1
RED_LIMIT = Pick.new(12, "red").freeze
GREEN_LIMIT = Pick.new(13, "green").freeze
BLUE_LIMIT = Pick.new(14, "blue").freeze

class Game
  attr_reader :id

  def initialize(id, raw_game_data)
    @id = id
    @picks = generate_picks(raw_game_data)
  end

  def possible?
    @picks.all?(&:possible?)
  end

  def generate_picks(raw_game_data)
    p = []
    raw_game_data.each_slice(2) do |pick|
      p << Pick.new(pick[0].to_i, pick[1])
    end
    p
  end
end

class AllGames
  attr_reader :games

  def initialize(input)
    @games = generate_games(input)    
  end

  def generate_games(input)
    g = []
    input.each_with_index do |raw_game_data, idx|
      g << Game.new(idx + 1, raw_game_data)
    end
    g
  end
end

p AllGames.new(input).games.select { _1.possible? }.map(&:id).sum
