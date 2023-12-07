PRIORITIES = ('a'..'z').to_a + ('A'..'Z').to_a

full_inventory = File.read("../test_input.txt").split("\n")

fulle_inventory.each_slice(3) { |group| group[0] & group[1] & gr}

errors = raw_rucksacks.map { |rs| rs[0] & rs[1] }.flatten

priority = errors.map { |err| PRIORITIES.index(err) + 1 }.sum

p priority
