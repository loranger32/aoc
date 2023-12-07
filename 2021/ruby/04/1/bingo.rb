# INPUT DATA EXTRACTION

puzzle_data = [] 

File.read("input.txt").each_line { puzzle_data << _1}

numbers = puzzle_data[0].chomp.split(",").map(&:to_i)

boards_data = [] 

puzzle_data[2..].each_slice(6) do |slice|
  slice.pop unless slice[5].nil?
  boards_data << slice.map(&:chomp)
end

boards_data.map! do |board|
  board.map { |line| line.split.map(&:to_i) }
end

p boards_data[0]

# Square, Board and game classes
class Square
  attr_reader :value, :line, :col

  def initialize(value, line, col)
    @value = value
    @line = line
    @col = col
    @checked = false
  end

  def checked?
    @checked
  end

  def check!
    @checked = true
  end
end

class Board
  attr_reader :squares
  def initialize(numbers_rows)
    @squares = map_squares_with(numbers_rows)
  end

  def is_winner?
    (1..5).any? do |number|
      col_complete?(number) || line_complete?(number)
    end
  end

  def col_complete?(col_number)
    @squares.select { |square| square.col == col_number}.all?(&:checked?)
  end

  def line_complete?(line_number)
    @squares.select { |square| square.line == line_number}.all?(&:checked?)
  end

  def check_square_with_value!(value)
    return unless has_value?(value)
    square_with_value(value).check!
  end

  def sum_unchecked_squares
    squares.select { !_1.checked? }.inject(0) {  _1 + _2.value }
  end

  private

    def map_squares_with(numbers_rows)
      squares = []
      numbers_rows.each_with_index do |row, row_index|
        row.each_with_index do |value, col_index|
          squares << Square.new(value, row_index + 1, col_index + 1)
        end
      end
      squares
    end

    def has_value?(value)
      squares.any? { _1.value == value}
    end

    def square_with_value(value)
      selected_square = squares.select {_1.value == value}
      raise StandardError, "Boom" unless selected_square.size == 1
      selected_square[0]
    end
end

class Game
  attr_reader :boards

  def initialize(boards_numbers)
    @boards = boards_numbers.map { |board_data| Board.new(board_data) }
  end

  def check_squares(value)
    boards.each { _1.check_square_with_value!(value) }
  end

  def is_winner?
    boards.any? { _1.is_winner? }
  end

  def winner_board
    return unless is_winner?
    boards.select { _1.is_winner? }[0]
  end

  def sum_winner_board
    winner_board.sum_unchecked_squares
  end
end


game = Game.new(boards_data)

winning_number = 0

numbers.each do |number|
  game.check_squares(number)
  winning_number = number
  break if game.is_winner?
end

p game.winner_board
p winning_number

sum = game.sum_winner_board

p sum

p sum * winning_number


# a = game.boards[0]
# [13,62,38,10,41].each { a.check_square_with_value!(_1) }

# p a.col_complete?(1)
# p a.line_complete?(1)
# # game.check_squares(13)
# # p game.is_winner?
# p a.is_winner?


