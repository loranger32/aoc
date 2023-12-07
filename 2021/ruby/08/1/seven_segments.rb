puzzle_data = File.read("../puzzle_data.txt").each_line.map { _1.split(" | ").map(&:split) }

UNIQUE_LENGTHES = [2, 4, 3, 7]

p puzzle_data.map { |entry| entry[1] }.flatten.select { UNIQUE_LENGTHES.include?(_1.length) }.count

