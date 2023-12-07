require "pry"

a = "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green"
m = a.scan(/(?=(\d [blue|red|green]))/).flatten

class Pick
  include Comparable

  attr_reader :value, :color

  def initialize(color, qty)
    @color = color
    @qty = qty
  end

  def possible?
    case @color
    when "r" then self <= RED_LIMIT
    when "g" then self <= GREEN_LIMIT
    when "b" then self <= BLUE_LIMIT
    end
  end

  def <=>(other)
    raise StandardError, "Wrong comparison" unless color == other.color
    value <=> other.value
  end
end

RED_LIMIT = Pick.new("12", "r")
GREEN_LIMIT = Pick.new("13", "g")
BLUE_LIMIT = Pick.new("14", "b")

class Game
  def initialize(input)
    @picks = generate_picks(input)
  end

  def possible?
    @picks.all?(&:possible?)
  end

  def generate_picks(input)
    input.each_with_object([]) do |data, picks|
      picks << Pick.new(*data.split)
    end
  end
end

p Game.new(m).possible?
