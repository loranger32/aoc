require "benchmark"

inventory = File.read("input.txt").split("\n\n").map { _1.split("\n").map(&:to_i).sum }.sort.reverse


# Part 1

p inventory.first

# Part 2

p inventory[..2].sum
