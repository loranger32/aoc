require "pry"

class SyntaxMachine
  OPENING_BRACKETS = ["(", "[", "{", "<"]
  CLOSING_BRACKETS = [")", "]", "}", ">"]
  MATCHINGS = {"(" => ")", ")" => "(", "[" => "]", "]" => "[", "{" => "}", "}" => "{", "<" => ">", ">" => "<"}

  SYNTAX_ERROR_SCORES = {")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  AUTO_COMPLETION_SCORES = {")" => 1, "]" => 2, "}" => 3, ">" => 4}


  def initialize(instructions)
    @instructions     = instructions
    @incorrects       = []
    @valid_lines      = []
    @auto_completions = []
    @parsed           = false
    @auto_completed   = false
  end

  def guard_clause
    parse_all unless @parsed
  end

  def incorrects
    guard_clause
    @incorrects
  end

  def valid_lines
    guard_clause
    @valid_lines
  end

  def parse_all
    @instructions.each { parse(_1) }
    @parsed = true
  end

  def parse(line)
    openings = []
    closings = []

    line.split("").each do |bracket|
      if OPENING_BRACKETS.include?(bracket)
        openings << bracket
      elsif CLOSING_BRACKETS.include?(bracket)
        if closings.size >= openings.size || openings.last != MATCHINGS[bracket]
          @incorrects << bracket
          return
        end
        openings.pop
      else
        raise "BOOOOM"
      end
    end

    @valid_lines << line
  end

  def syntax_errors_score
    guard_clause
    @incorrects.reduce(0) { |acc, bracket| acc + SYNTAX_ERROR_SCORES[bracket] }
  end


  def autocomplete_all
    valid_lines.each { @auto_completions << autocomplete(_1) }
    @auto_completed = true
  end

  def auto_completions
    autocomplete_all unless @auto_completed
    @auto_completions
  end

  def autocomplete(line)
    closings = []
    openings = []
    completion = ""

    line.split("").reverse.each do |bracket|
      if CLOSING_BRACKETS.include?(bracket)
        closings << bracket
      elsif OPENING_BRACKETS.include?(bracket)
        if closings.last == MATCHINGS[bracket]
          closings.pop
        else
          completion << MATCHINGS[bracket]
        end
      else
        raise "BOOOM"
      end
    end
    completion
  end

  def autocomplete_score
    scores = auto_completions.map do |line|
      line.split("").reduce(0) { |acc, bracket| acc * 5 + AUTO_COMPLETION_SCORES[bracket] }
    end
    scores.sort[scores.size / 2]
  end
end


puzzle_data = File.read("../puzzle_data.txt").each_line.map { _1.chomp }

sm = SyntaxMachine.new(puzzle_data)

pp sm.autocomplete_score
