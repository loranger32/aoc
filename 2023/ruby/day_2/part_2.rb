INPUT = "input.txt"
TEST_INPUT = "test_input.txt"

input = File.read(INPUT).split("\n")
                        .map { _1.sub(/Game \d{1,3}: /, "") }
                        .map { _1.delete(",;:") }
                        .map(&:split)

COLORS = %w[red green blue].freeze

class Pick
  attr_reader :qty, :color

  def initialize(qty, color)
    @color = color
    @qty = qty
  end
end

class Game
  attr_reader :id

  def initialize(id, raw_game_data)
    @id = id
    @picks = generate_picks(raw_game_data)
  end

  def min_picks_powers
    min_picks.reduce(1) { |el, acc| acc = el * acc }
  end

  private

    def generate_picks(raw_game_data)
      p = []
      raw_game_data.each_slice(2) do |pick|
        p << Pick.new(pick[0].to_i, pick[1])
      end
      p
    end

    def min_picks
      COLORS.map { max(_1) }
    end

    def max(color)
      @picks.select { _1.color == color}.map(&:qty).max
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

p AllGames.new(input).games.map(&:min_picks_powers).sum
