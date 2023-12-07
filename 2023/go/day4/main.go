package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

const (
	input     = "input.txt"
	testInput = "test_input.txt"
)

type card struct {
	id             int
	winningNumbers []string
	actualNumbers  []string
}

func (c *card) value() int {
	winning := false
	score := 0

	for _, wn := range c.winningNumbers {
		for _, an := range c.actualNumbers {
			if wn == an {
				if winning == false {
					score = 1
					winning = true
				} else {
					score *= 2
				}
			}
		}
	}

	return score
}

func (c *card) points() int {
	score := 0

	for _, wn := range c.winningNumbers {
		for _, an := range c.actualNumbers {
			if wn == an {
				score += 1
			}
		}
	}

	return score
}

func main() {
	lines := getLines(testInput)
	//part1(lines)
	part2(lines)
}

func part1(lines []string) {
	cards := extractCards(lines)

	sum := 0
	for _, c := range cards {
		fmt.Printf("Id: %d, value: %d\n", c.id, c.value())
		sum += c.value()
	}

	fmt.Printf("The sum of all winning cards is: %d\n", sum)
}

func part2(lines []string) {
	cards := extractCards(lines)
	totalCards := len(cards)

	for _, c := range cards {
		totalCards += computeWinningCards(c, cards)
	}

	fmt.Printf("The total of cards is: %d\n", totalCards)
}

func computeWinningCards(c card, cards []card) int {
	points := c.points()

	if points == 0 {
		return points
	}

	for _, copyOfCard := range cards[c.id : c.id+points] {
		points += computeWinningCards(copyOfCard, cards)
	}

	return points
}

func extractCards(lines []string) []card {
	rePrefix := regexp.MustCompile(`Card\s+\d+: `)
	reNumbers := regexp.MustCompile(`\d{1,2}`)

	var cards []card

	for idx, line := range lines {
		line = rePrefix.ReplaceAllString(line, "")
		splitted := strings.Split(line, "|")
		winningNumbers, actualNumbers := splitted[0], splitted[1]
		cards = append(cards, card{id: idx + 1,
			winningNumbers: reNumbers.FindAllString(winningNumbers, -1),
			actualNumbers:  reNumbers.FindAllString(actualNumbers, -1)})
	}

	return cards
}

func getLines(path string) []string {
	bytes, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return strings.Split(strings.TrimSpace(string(bytes)), "\n")
}
