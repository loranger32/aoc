PUZZLA_DATA = File.read("../larger_test_data.txt").each_line.map { _1.split(" | ").map(&:split) }

PUZZLA_DATA
