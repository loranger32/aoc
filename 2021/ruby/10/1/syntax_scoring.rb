require "pry"

# Shameless Monkey Patching
class String
  def do_not_match(bracket)
    case self
    when "("
      true unless bracket == ")"
    when "{"
      true unless bracket == "}"
    when "["
      true unless bracket == "]"
    when "<"
      true unless bracket == ">"
    else
      raise "BOOM - Unexcepcted closing bracket : #{bracket}"
    end
  end
end

class SyntaxMachine
  OPENING_BRACKETS = ["(", "[", "{", "<"]
  CLOSING_BRACKETS = [")", "]", "}", ">"]

  SCORES = { ")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  attr_reader :incorrects

  def initialize(instructions)
    @instructions = instructions
    @incorrects = []
  end

  def parse_all
    @instructions.each do |line|
      parse(line)
    end
  end

  def parse(line)
    openings = []
    closings = []

    line.split("").each do |bracket|
      if OPENING_BRACKETS.include?(bracket)
        openings << bracket
      elsif CLOSING_BRACKETS.include?(bracket)
        if closings.size >= openings.size || openings.last.do_not_match(bracket)
          @incorrects << bracket
          return
        end
        openings.pop
      else
        raise "BOOOOM"
      end
    end
  end

  def score
    counter = 0
    @incorrects.each { |bracket| counter += SCORES[bracket] }
    counter
  end

end


puzzle_data = File.read("../puzzle_data.txt").each_line.map { _1.chomp }

pp puzzle_data[2]
sm = SyntaxMachine.new(puzzle_data)
sm.parse_all
pp sm.incorrects
pp sm.score
