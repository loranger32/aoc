require "pry"

class PathFinder
  attr_reader :lowests, :basins

  def initialize(squares_map)
    @squares = create_squares_hash(squares_map)
    @position = [0, 0]
    @height = squares_map.size
    @width = squares_map[0].size
    @lowests = []
    @basins = []
  end

  def find_lowests
    @height.times do |y_index|
      @width.times do |x_index|
        current_square = {[x_index, y_index] => @squares[[x_index, y_index]]}
        lowests << current_square if lowest_from_neighbours(current_square)
      end
    end
    lowests
  end

  def lowest_from_neighbours(square)
    [up(square), down(square), left(square), right(square)].all? { _1 }
  end

  def up(square)
    x, y = square.keys[0]
    if @squares[[x, y - 1]]
      @squares[[x, y - 1]] > square.values[0]
    else 
      true
    end
  end

  def down(square)
    x, y = square.keys[0]
    if @squares[[x, y + 1]]
      @squares[[x, y + 1]] > square.values[0]
    else 
      true
    end
  end

  def right(square)
    x, y = square.keys[0]
    if @squares[[x + 1, y]]
      @squares[[x + 1, y]] > square.values[0]
    else 
      true
    end
  end

  def left(square)
    x, y = square.keys[0]
    if @squares[[x - 1, y]]
      @squares[[x - 1, y]] > square.values[0]
    else 
      true
    end
  end

  def total_risk
    find_lowests.size + lowests.map { _1.values[0] }.reduce(&:+)
  end

  def find_basins
    lowests.each do |square|
      basin = []
      basin << search_basin_squares_from(square, basin)
      basin.pop # Remove last array full of other same arrays, still don't know why it happens, recusrions issue to be found out
      @basins << basin
    end
    @basins
  end

  def search_basin_squares_from(square, basin)
    return if [-1, 9].include?(square.values[0])

    x, y = square.keys[0]
    basin << square
    @squares[[x, y]] = -1

    search_basin_squares_from({[x + 1, y] => @squares[[x + 1, y]]}, basin) if @squares[[x + 1, y]]
    search_basin_squares_from({[x - 1, y] => @squares[[x - 1, y]]}, basin) if @squares[[x - 1, y]]
    search_basin_squares_from({[x, y + 1] => @squares[[x, y + 1]]}, basin) if @squares[[x, y + 1]]
    search_basin_squares_from({[x, y - 1] => @squares[[x, y - 1]]}, basin) if @squares[[x, y - 1]]

    basin
  end

  private

    def create_squares_hash(squares_map)
      mapping = {}
      squares_map.each_with_index do |row, y_index|
        row.each_with_index do |depth, x_index|
          mapping[[x_index, y_index]] = depth
        end
      end
      mapping
    end
end


puzzle_data = File.read("../test_data.txt").each_line.map(&:chomp).map { _1.split("").map(&:to_i) }
pf = PathFinder.new(puzzle_data)
pf.find_lowests
pf.find_basins

pp pf.basins.map(&:size).sort[-3..-1].reduce(&:*)




