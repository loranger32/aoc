package main

import (
	"fmt"
	"os"
	"sort"
	"strconv"
	"strings"
)

type combo uint8

const (
	highCard combo = iota
	onePair
	twoPairs
	threeOfAKind
	full
	fourOfAKind
	fiveOfAKind
	input     = "input.txt"
	testInput = "test_input.txt"
)

var cardValues = map[string]int{"J": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "T": 10, "Q": 11,
	"K": 12, "A": 13}

type hand struct {
	cards         []string
	cardsStr      string
	filteredCards []string
	class         combo
	bid           int
	jokers        int
}

func (h *hand) findClass() error {
	switch {
	case h.isFiveOfAKind():
		h.class = fiveOfAKind
	case h.isFourOfAKind():
		h.class = fourOfAKind
	case h.isFull():
		h.class = full
	case h.isThreeOfAKind():
		h.class = threeOfAKind
	case h.isTwoPairs():
		h.class = twoPairs
	case h.isOnePair():
		h.class = onePair
	case h.isHighCard():
		h.class = highCard
	default:
		return fmt.Errorf("unable to find class of hand: %v", h)
	}
	return nil
}

func (h *hand) isFiveOfAKind() bool {
	return len(h.filteredCards) <= 1
}

func (h *hand) isFourOfAKind() bool {
	if len(h.filteredCards) != 2 {
		return false
	}

	return strings.Count(h.cardsStr, h.filteredCards[0])+h.jokers == 4 ||
		strings.Count(h.cardsStr, h.filteredCards[1])+h.jokers == 4
}

func (h *hand) isFull() bool {
	if len(h.filteredCards) != 2 {
		return false
	}

	return (strings.Count(h.cardsStr, h.filteredCards[0])+h.jokers == 3 &&
		strings.Count(h.cardsStr, h.filteredCards[1]) == 2) ||
		(strings.Count(h.cardsStr, h.filteredCards[0]) == 2 &&
			strings.Count(h.cardsStr, h.filteredCards[1])+h.jokers == 3)
}

func (h *hand) isThreeOfAKind() bool {
	if len(h.filteredCards) != 3 {
		return false
	}

	return strings.Count(h.cardsStr, h.filteredCards[0])+h.jokers == 3 ||
		strings.Count(h.cardsStr, h.filteredCards[1])+h.jokers == 3 ||
		strings.Count(h.cardsStr, h.filteredCards[2])+h.jokers == 3
}

func (h *hand) isTwoPairs() bool {
	return len(h.filteredCards)+h.jokers == 3 && !h.isThreeOfAKind() && !h.isFull()
}

func (h *hand) isOnePair() bool {
	return len(h.filteredCards) == 4
}

func (h *hand) isHighCard() bool {
	return len(h.filteredCards) == 5
}

func main() {
	part2(input)
}

func part2(path string) {
	hands := getHands(path)

	for _, h := range hands {
		err := h.findClass()
		if err != nil {
			panic(err)
		}
	}

	orderHands(hands)

	score := 0
	for i, h := range hands {
		score += h.bid * (i + 1)
	}

	fmt.Println("Total if winning points is: ", score)
}

func getHands(path string) []*hand {
	var hands []*hand

	raw, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}

	for _, h := range strings.Split(string(raw), "\n") {
		data := strings.Fields(h)
		cardsStr := data[0]
		filteredCards := removeDupAndJokers(cardsStr)
		bid, err := strconv.Atoi(data[1])
		if err != nil {
			panic(err)
		}

		hands = append(hands, &hand{cards: strings.Split(cardsStr, ""),
			cardsStr:      cardsStr,
			bid:           bid,
			jokers:        strings.Count(cardsStr, "J"),
			filteredCards: filteredCards,
		})
	}

	return hands
}

func removeDupAndJokers(cards string) []string {
	var filteredCards []string
	keys := make(map[string]bool)

	for _, c := range strings.Split(cards, "") {
		_, ok := keys[c]
		if !ok && c != "J" {
			keys[c] = true
			filteredCards = append(filteredCards, c)
		}
	}

	return filteredCards
}

func orderHands(hands []*hand) {
	sort.SliceStable(hands, func(i, j int) bool {
		if hands[i].class != hands[j].class {
			return hands[i].class < hands[j].class
		}
		for y := 0; y < 5; y++ {
			if hands[i].cards[y] != hands[j].cards[y] {
				return cardValues[hands[i].cards[y]] < cardValues[hands[j].cards[y]]
			}
		}
		panic(fmt.Errorf("identical cards found: 1. %+v, 2. %+v", hands[i], hands[j]))
	})
}
