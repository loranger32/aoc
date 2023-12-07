### SEGMENT OCCURENCES
# top          = 8
# top left     = 6  *
# top right    = 8
# center       = 7
# bottom left  = 4  *
# bottom right = 9  *
# bottom       = 7

class RewireMachine
  SEGMENT_TEMPLATE = {top: nil, top_left: nil, top_right: nil, center: nil,
    bottom_left: nil, bottom_right: nil, bottom: nil}
  
  UNIQUE_LENGTHES = [2, # 1
                     4, # 4
                     3, # 7
                     7] # 8

  attr_reader :template

  def initialize(signals)
    @template = SEGMENT_TEMPLATE.dup
    @signals = signals
    @unique_lengthes = select_unique_lengthes
    @signals_occurences = @signals.map { _1.split("") }.flatten.tally 
  end

  def rights_segments
    @unique_lengthes[0].split("") & @unique_lengthes[1].split("")
  end

  def top_segment!
    @template[:top] = (@unique_lengthes[1].split("") - @unique_lengthes[0].split(""))[0]  
  end

  def top_left!
    template[:top_left] = @signals_occurences.select { |_, v| v == 6 }.keys[0]
  end

  def bottom_left!
    template[:bottom_left] = @signals_occurences.select { |_, v| v == 4 }.keys[0]
  end

  def bottom_right!
    template[:bottom_right] = @signals_occurences.select { |_, v| v == 9 }.keys[0]
  end

  def top_right!
    template[:top_right] = (rights_segments - [template[:bottom_right]])[0]
  end

  def center_and_bottom_segments
    @signals_occurences.select { |_, v| v == 7 }.keys
  end

  def center!
    template[:center] = (@unique_lengthes[2].split("") & center_and_bottom_segments)[0]
  end

  def bottom!
    template[:bottom] = (center_and_bottom_segments - [template[:center]])[0]
  end


  def rewire
    top_segment!
    top_left!
    bottom_left!
    bottom_right!
    top_right!
    center!
    bottom!
    template
  end

  private

    def select_unique_lengthes
      @signals.select { UNIQUE_LENGTHES.include?(_1.length) }.sort { |a, b| a.length <=> b.length }.flatten
    end
end

class DigitMapper
  # Hash not really needed, but easier to read
  MAPPINGS = {"0" => [:top, :top_left, :top_right, :bottom_left, :bottom_right, :bottom],
              "1" => [:top_right, :bottom_right],
              "2" => [:top, :top_right, :center, :bottom_left, :bottom],
              "3" => [:top, :top_right, :center, :bottom_right, :bottom],
              "4" => [:top_left, :top_right, :center, :bottom_right],
              "5" => [:top, :top_left, :center, :bottom_right, :bottom],
              "6" => [:top, :top_left, :center, :bottom_left, :bottom_right, :bottom],
              "7" => [:top, :top_right, :bottom_right],
              "8" => [:top, :top_left, :top_right, :center, :bottom_left, :bottom_right, :bottom],
              "9" => [:top, :top_left, :top_right, :center, :bottom_right, :bottom]}

  def initialize(mapper)
    @mapper = mapper
  end

  def map_all_digits
    MAPPINGS.values.map { |mapping| map_one_digit(mapping) }
  end

  def map_one_digit(digit_segments)
    output = ""
    digit_segments.each do |segment|
      output += @mapper[segment]
    end
    output.split("").sort.join
  end
  
  def convert_signal_to_digit(segments)
    digits = []
    MAPPINGS.values.each do |digit_map| 
      
      digits << segments.map { |segment| digit += @mapper[segment] }
      digit.split("").sort.join
    end
  end
end

class Convertor
  def convert(digits_segments, output)
    output.map! { _1.split("").sort.join }
    output.map { |output_segment| digits_segments.index(output_segment).to_s }.join
  end
end


puzzle_data = File.read("../puzzle_data.txt").each_line.map { _1.split(" | ").map(&:split) }

digits = []

puzzle_data.each do |entry|
  mapper = RewireMachine.new(entry[0]).rewire
  mapping = DigitMapper.new(mapper).map_all_digits
  digits << Convertor.new.convert(mapping, entry[1])
end

pp digits.map(&:to_i).reduce(&:+)
