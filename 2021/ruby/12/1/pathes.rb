require "pry"

class Segment
  attr_reader :a, :b

  def initialize(a, b)
    @a = a
    @b = b
  end

  def linked?(other)
    (a == other.a || a == other.b || b == other.a || b == other.b) && !(a == other.a && b == other.b)
  end
end

class Path
  def initialize(start = [])
    @segments = start
  end

  def add(segment)
    @segments << segment
  end
end

class PathFinder
  attr_reader :segments, :starting_segments

  def initialize(segments)
    @starting_segments = segments.select { [_1.a, _1.b].include?("start") }
    @segments = segments - starting_segments
    @pathes = []
  end

  def find_all_pathes
    @starting_segments.each do |segment|
      remaining_segments = segments.dup
      path = Path.new(segment)
      @pathes << find_next_segment(starting_segment, remaining_segments, path)
    end
    @pathes
  end

  def find_next_segment(base_segment, remaining_segments, path)
    return if remaining_segments.empty?

    remaining_segments -= [base_segment]
    connected_segments = remaining_segments.select { |other_segment| base_segment.linked?(other_segment) }
    remaining_segments -= connected_segments
    connected_segments.each_with_index { |connected_segment, index| path << [path[index], connected_segment] }
    connected_segments.each_with_index do |new_base_segment, index|
      find_next_segment(new_base_segment, remaining_segments, path[index])
    end
    path
  end
end

puzzle_data = File.read("../test_data.txt").split.map { |seg| seg.split("-") }
segments = puzzle_data.map do |seg|
  Segment.new(*seg)
end

pf = PathFinder.new(segments)

pp pf.find_all_pathes.map(&:uniq)
