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

class Round
  WIN = 6
  DRAW = 3

  Hand = Data.define(:name, :points)

  ROCK = Hand.new("Rock", 1)
  PAPER = Hand.new("Paper", 2)
  SCISSORS = Hand.new("Scissors", 3)

  HANDS_TABLE = {"A" => ROCK, "X" => ROCK, "B" => PAPER, "Y" => PAPER, "C" => SCISSORS, "Z" => SCISSORS}.freeze

  def initialize(other, me)
    @other = HANDS_TABLE[other]
    @me = HANDS_TABLE[me]
  end

  def score
    @score ||= compute_score
  end

  def compute_score
    score = @me.points
    score += WIN if win?
    score += DRAW if draw?
    score
  end

  def draw?
    @other == @me
  end

  def win?
    @other == ROCK && @me == PAPER ||
      @other == PAPER && @me == SCISSORS ||
      @other == SCISSORS && @me == ROCK
  end

  def loss?
    !(draw? || win?)
  end
end

p Rps.new(File.read("input.txt")).score
