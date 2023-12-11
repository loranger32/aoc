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

var cardValues = map[string]int{"2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9, "T": 10, "J": 11,
	"Q": 12, "K": 13, "A": 14}

type hand struct {
	cards          []string
	class          combo
	bid            int
	differentCards []string
}

func (h *hand) findClass() error {
	switch {
	case h.isFiveOfAKind():
		h.class = fiveOfAKind
	case h.isFull():
		h.class = full
	case h.isFourOfAKind():
		h.class = fourOfAKind
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
	return len(h.differentCards) == 1
}

func (h *hand) isFourOfAKind() bool {
	if len(h.differentCards) != 2 {
		return false
	}

	return strings.Count(strings.Join(h.cards, ""), h.differentCards[0]) == 4 ||
		strings.Count(strings.Join(h.cards, ""), h.differentCards[1]) == 4
}

func (h *hand) isFull() bool {
	if len(h.differentCards) != 2 {
		return false
	}

	cardsStr := strings.Join(h.cards, "")

	return (strings.Count(cardsStr, h.differentCards[0]) == 3 &&
		strings.Count(cardsStr, h.differentCards[1]) == 2) ||
		(strings.Count(cardsStr, h.differentCards[0]) == 2 &&
			strings.Count(cardsStr, h.differentCards[1]) == 3)
}

func (h *hand) isThreeOfAKind() bool {
	if len(h.differentCards) != 3 {
		return false
	}

	cardsStr := strings.Join(h.cards, "")

	return strings.Count(cardsStr, h.differentCards[0]) == 3 ||
		strings.Count(cardsStr, h.differentCards[1]) == 3 ||
		strings.Count(cardsStr, h.differentCards[2]) == 3
}

func (h *hand) isTwoPairs() bool {
	return len(h.differentCards) == 3 && !h.isThreeOfAKind()
}

func (h *hand) isOnePair() bool {
	return len(h.differentCards) == 4
}

func (h *hand) isHighCard() bool {
	return len(h.differentCards) == 5
}

func main() {
	part1(input)
}

func part1(path string) {
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
		cards := strings.Split(data[0], "")
		bid, err := strconv.Atoi(data[1])
		if err != nil {
			panic(err)
		}

		hands = append(hands, &hand{cards: cards, bid: bid, differentCards: removeDup(cards)})
	}

	return hands
}

func removeDup(cards []string) []string {
	var uniques []string
	keys := make(map[string]bool)

	for _, c := range cards {
		_, ok := keys[c]
		if !ok {
			keys[c] = true
			uniques = append(uniques, c)
		}
	}

	return uniques
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
