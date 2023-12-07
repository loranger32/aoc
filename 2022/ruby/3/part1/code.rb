PRIORITIES = ('a'..'z').to_a + ('A'..'Z').to_a

full_inventory = File.read("../input.txt").split("\n")
raw_rucksacks = full_inventory.map { |rs| [rs[..(rs.length / 2)-1].split(""), rs[(rs.length / 2)..].split("")] }

errors = raw_rucksacks.map { |rs| rs[0] & rs[1] }.flatten

priority = errors.map { |err| PRIORITIES.index(err) + 1 }.sum

p priority
