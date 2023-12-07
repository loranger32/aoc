package main

import (
	"bytes"
	"fmt"
	"os"
)

const (
	input     = "../part1/input.txt"
	testInput = "../part1/test_input.txt"
)

type rucksack struct {
	first, second []byte
}

func (r rucksack) findBadges() byte {
	firstAsMap := createMapFrom(r.first)

	for _, el := range r.second {
		if firstAsMap[el] {
			return el
		}
	}

	var b byte
	return b
}

func computePriority(misplaced []byte) int {
	total := 0
	for _, mp := range misplaced {
		if mp > 64 && mp < 91 {
			total += int(mp) - 64 + 26
		}

		if mp > 96 && mp < 123 {
			total += int(mp) - 96
		}
	}
	return total
}

func main() {
	rawSplitted := gatherInput(input)
	rucksacks := createRucksacks(rawSplitted)

	var badges []byte

	for _, sack := range rucksacks {
		badges = append(badges, sack.findBadges())
	}

	priority := computePriority(badges)
	fmt.Println(priority)
}

func createRucksacks(allItems [][]byte) []rucksack {
	var ruckscaks []rucksack
	for _, allRucksackItems := range allItems {
		r := rucksack{allRucksackItems[:len(allRucksackItems)/2],
			allRucksackItems[len(allRucksackItems)/2:]}
		ruckscaks = append(ruckscaks, r)
	}
	return ruckscaks
}

func gatherInput(path string) [][]byte {
	rawContent, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	splitted := bytes.Split(rawContent, []byte("\n"))
	return splitted
}

func createMapFrom(compartiment []byte) map[byte]bool {
	compartimentMap := make(map[byte]bool)
	for _, el := range compartiment {
		compartimentMap[el] = true
	}
	return compartimentMap
}
