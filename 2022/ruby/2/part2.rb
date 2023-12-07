
require "pry"

class Rps
  def initialize(rounds)
    @rounds = create_rounds(rounds)
  end

  def score
    @rounds.map(&:score).sum
  end

  private

    def create_rounds(rounds)
      rounds.split("\n").map(&:split).each_with_object([]) do |round, rounds|
        rounds << Round.new(*round)
      end
    end
end

class Move
  MOVES = {"A" => [:rock, 1], "B" => [:paper, 2], "C" => [:scissors, 3]}.freeze

  attr_reader :name, :points

  def initialize(code)
    @name, @points = MOVES[code]
  end

  def beats
    case @name
    when :rock then self.class.new("C")
    when :paper then self.class.new("A")
    when :scissors then self.class.new("B")
    end
  end

  def lose_against
    case @name
    when :rock then self.class.new("B")
    when :paper then self.class.new("C")
    when :scissors then self.class.new("A")
    end
  end

  def ==(other)
    @name == other.name
  end
end

class Round
  WIN = 6
  DRAW = 3

  MUST_WIN = "Z"
  MUST_DRAW = "Y"
  MUST_LOOSE = "X"

  def initialize(other, me)
    @other = Move.new(other)
    @me = pick_move(me)
  end

  def score
    score = @me.points
    score += WIN if win?
    score += DRAW if draw?
    score
  end

  private

    def draw?
      @other == @me
    end

    def pick_move(me)
      case me
      when MUST_LOOSE then @other.beats
      when MUST_DRAW then @other.dup
      when MUST_WIN then @other.lose_against
      end
    end

    def loss?
      !(draw? || win?)
    end

    def win?
      @other.name == :rock && @me.name == :paper ||
        @other.name == :paper && @me.name == :scissors ||
        @other.name == :scissors && @me.name == :rock
    end
end

p Rps.new(File.read("input.txt")).score
