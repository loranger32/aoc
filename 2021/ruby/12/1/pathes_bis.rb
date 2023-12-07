require "pry"

class Node
  attr_reader :value

  def initialize(value, connected = nil)
    @value = value
    @connected_nodes = [connected].compact
  end

  def nexts
    @connected_nodes
  end

  def add(node)
    @connected_nodes << node
  end

  def start?
    @value == "start"
  end

  def end?
    @value == "end"
  end
end


class PathFinder

  attr_reader :starting_nodes

  def initialize(segments)
    @segments = segments
    @starting_nodes = create_nodes(segments, "start")
  end

  def trace_pathes
    segments = @segments.dup
    @starting_nodes.each do |starting_node|
      starting_node.nexts.each do |next_node|
        connecteds = segments.select { |seg| [seg[0], seg[1]].include? next_node.value }
        connecteds.each do |con| 
          next_node.add(Node.new(con))
        end
      end
    end
  end

  private

    def create_nodes(segments, value = nil)
      if value
        nodes = []
        relevant_segments = segments.select { [_1[0], _1[1]].include?(value) }
        relevant_segments.each do |segment|
          starting, ending = segment.partition { |el| el == value }
          nodes << Node.new(starting, Node.new(ending))
        end
      end
      nodes
    end
end

puzzle_data = File.read("../test_data.txt").split.map { |seg| seg.split("-") }
pf = PathFinder.new(puzzle_data)

pp pf

