package main

import (
	"fmt"
	"os"
	"strings"
)

// Part Two

const (
	input     = "input.txt"
	testInput = "test_input.txt"
	win       = 6
	draw      = 3
	mustWin   = "Z"
	mustDraw  = "Y"
	mustLoose = "X"
)

var (
	rock     = move{"rock", 1}
	paper    = move{"paper", 2}
	scissors = move{"scissors", 3}
)

var movesTable = map[string]move{"A": rock, "B": paper, "C": scissors}

func main() {
	rawRounds, err := gatherInput(input)
	if err != nil {
		panic(err)
	}
	score := 0
	rounds := createRounds(rawRounds)
	if err != nil {
		panic(err)
	}
	for _, r := range rounds {
		score += r.score()
	}

	fmt.Println(score)
}

type move struct {
	name   string
	points int
}

func (m move) beats() move {
	switch m {
	case rock:
		return scissors
	case paper:
		return rock
	case scissors:
		return paper
	default:
		panic(fmt.Errorf("rock, paper or scissors expected, got %v instead", m))
	}
}

func (m move) looseAgainst() move {
	switch m {
	case rock:
		return paper
	case paper:
		return scissors
	case scissors:
		return rock
	default:
		panic(fmt.Errorf("rock, paper or scissors expected, got %v instead", m))
	}
}

type round struct {
	other, me move
}

func (r round) score() int {
	s := r.me.points
	if r.win() {
		s += win
	}
	if r.draw() {
		s += draw
	}
	return s
}

func (r round) win() bool {
	return r.other == rock && r.me == paper ||
		r.other == paper && r.me == scissors ||
		r.other == scissors && r.me == rock
}

func (r round) draw() bool {
	return r.other == r.me
}

func gatherInput(fileName string) ([]string, error) {
	rawBytes, err := os.ReadFile(fileName)
	if err != nil {
		return []string{}, err
	}

	rawString := string(rawBytes)
	splitted := strings.Split(strings.TrimSpace(rawString), "\n")

	return splitted, nil
}

func createRounds(data []string) []round {
	var rounds []round

	for _, r := range data {
		otherAndMe := strings.Split(r, " ")
		other := otherAndMe[0]
		strategy := otherAndMe[1]
		newRound := round{other: movesTable[other], me: pickMove(strategy, movesTable[other])}
		rounds = append(rounds, newRound)
	}
	return rounds
}

func pickMove(strategy string, other move) move {
	switch strategy {
	case mustDraw:
		return other
	case mustWin:
		return other.looseAgainst()
	case mustLoose:
		return other.beats()
	default:
		panic(fmt.Errorf("strategy must be X, Y or Z, got %v instead", strategy))
	}
}

// Part One

//const input = "input.txt"
//const testInput = "test_input.txt"
//const rock = "rock"
//const paper = "paper"
//const scissors = "scissors"
//const win = 6
//const draw = 3
//
//var movesTable = map[string]move{"A": {rock, 1}, "X": {rock, 1},
//	"B": {paper, 2}, "Y": {paper, 2}, "C": {scissors, 3},
//	"Z": {scissors, 3}}
//
//func main() {
//	rawRounds, err := gatherInput(input)
//	if err != nil {
//		panic(err)
//	}
//	score := 0
//	rounds := createRounds(rawRounds)
//	if err != nil {
//		panic(err)
//	}
//	for _, r := range rounds {
//		score += r.score()
//	}
//
//	fmt.Println(score)
//}
//
//type move struct {
//	name   string
//	points int
//}
//
//type round struct {
//	other, me move
//}
//
//func (r round) score() int {
//	s := r.me.points
//	if r.win() {
//		s += win
//	}
//	if r.draw() {
//		s += draw
//	}
//	return s
//}
//
//func (r round) win() bool {
//	return r.other.name == rock && r.me.name == paper ||
//		r.other.name == paper && r.me.name == scissors ||
//		r.other.name == scissors && r.me.name == rock
//}
//
//func (r round) draw() bool {
//	return r.other.name == r.me.name
//}
//
//func gatherInput(fileName string) ([]string, error) {
//	rawBytes, err := os.ReadFile(fileName)
//	if err != nil {
//		return []string{}, err
//	}
//
//	rawString := string(rawBytes)
//	splitted := strings.Split(strings.TrimSpace(rawString), "\n")
//
//	return splitted, nil
//}
//
//func createRounds(data []string) []round {
//	var rounds []round
//
//	for _, r := range data {
//		otherAndMe := strings.Split(r, " ")
//		other := otherAndMe[0]
//		me := otherAndMe[1]
//		newRound := round{other: movesTable[other], me: movesTable[me]}
//		rounds = append(rounds, newRound)
//	}
//	return rounds
//}
