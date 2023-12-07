require "pry"
class PathFinder
  attr_reader :lowests

  def initialize(squares_map)
    @squares_map = squares_map
    @height = @squares_map.size - 1
    @width = @squares_map[0].size - 1
    @lowests = []
  end

  def find_lowests
    @squares_map.each_with_index do |row, y_index|
      row.each_with_index do |depth, x_index|

        case y_index
        # First row
        when 0 then first_row_lowests!(depth, row, x_index)
       # Bottom Row
        when @height then last_row_lowests!(depth, row, x_index)  
        else
          middle_rows_lowests!(depth, row, x_index, y_index)
        end
      end
    end
    lowests
  end

  def total_risk
    find_lowests.size + lowests.reduce(&:+)
  end

  private

    def right_higher?(depth, row, x_index)
      depth < row[x_index + 1]
    end

    def left_higher?(depth, row, x_index)
      depth < row[x_index - 1]
    end

    def left_and_right_higher?(depth, row, x_index)
      left_higher?(depth, row, x_index) && right_higher?(depth, row, x_index)
    end

    def below_higher?(depth, x_index, y_index)
      depth < @squares_map[y_index + 1][x_index]
    end

    def top_higher?(depth, x_index, y_index)
      depth < @squares_map[y_index - 1][x_index]
    end

    def top_and_below_higher?(depth, x_index, y_index)
      below_higher?(depth, x_index, y_index) && top_higher?(depth, x_index, y_index)
    end

    def first_row_lowests!(depth, row, x_index)
      # Top Left Corner
      if x_index == 0
        lowests << depth if right_higher?(depth, row, x_index) && below_higher?(depth, x_index, 0)
      
      # Top Right Corner
      elsif x_index == @width
        lowests << depth if left_higher?(depth, row, x_index) && below_higher?(depth, x_index, 0)
      
      else
        lowests << depth if left_and_right_higher?(depth, row, x_index) && below_higher?(depth, x_index, 0)
      end
    end

    def last_row_lowests!(depth, row, x_index)
      # Bottom Left Corner
      if x_index == 0
        lowests << depth if right_higher?(depth, row, x_index) && top_higher?(depth, x_index, @height)

      #Bottom Right Corner
      elsif x_index == @width
        lowests << depth if left_higher?(depth, row, x_index) && top_higher?(depth, x_index, @height)

      else
        lowests << depth if left_and_right_higher?(depth, row, x_index) && top_higher?(depth, x_index, @height)
      end
    end

    def middle_rows_lowests!(depth, row, x_index, y_index)
      if x_index == 0
        lowests << depth if top_and_below_higher?(depth, x_index, y_index) && right_higher?(depth, row, x_index)
      elsif x_index == @width
        lowests << depth if top_and_below_higher?(depth, x_index, y_index) && left_higher?(depth, row, x_index)
      else
        lowests << depth if top_and_below_higher?(depth, x_index, y_index) && left_and_right_higher?(depth, row, x_index)
      end
    end
end

puzzle_data = File.read("../puzzle_data.txt").each_line.map(&:chomp).map { _1.split("").map(&:to_i) }
pp PathFinder.new(puzzle_data).total_risk
