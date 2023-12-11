package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const (
	input     = "input.txt"
	testInput = "test_input.txt"
)

type race struct {
	time, record int
}

func (r *race) wins() int {
	counter := 0
	for i := 1; i < r.time; i++ {
		if i*(r.time-i) > r.record {
			counter += 1
		}
	}
	return counter
}

func main() {
	//part1(input)
	part2(input)
}

func part1(path string) {
	races := getRaces(input)
	possibleWins := 1
	for _, r := range races {
		possibleWins *= r.wins()
	}

	fmt.Println("Total number of possible wins: ", possibleWins)
}

func getRaces(path string) []race {
	byteContent, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	rawContent := strings.TrimSpace(string(byteContent))

	splitted := strings.Split(rawContent, "\n")
	times := strings.Fields(splitted[0])[1:]
	records := strings.Fields(splitted[1])[1:]

	var races []race
	for i := 0; i < len(times); i++ {
		t, err1 := strconv.Atoi(times[i])
		if err1 != nil {
			panic(err1)
		}
		r, err2 := strconv.Atoi(records[i])
		if err2 != nil {
			panic(err2)
		}

		races = append(races, race{t, r})
	}

	return races
}

func part2(path string) {
	race := getRace(path)
	fmt.Println("Total winning ways: ", race.wins())
}

func getRace(path string) race {
	byteContent, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	lines := strings.Split(strings.TrimSpace(string(byteContent)), "\n")

	timeStr := strings.Join(strings.Fields(lines[0])[1:], "")
	recordStr := strings.Join(strings.Fields(lines[1])[1:], "")

	t, err := strconv.Atoi(timeStr)
	if err != nil {
		panic(err)
	}

	r, err := strconv.Atoi(recordStr)
	if err != nil {
		panic(err)
	}

	return race{t, r}
}
