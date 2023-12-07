package main

import (
	"fmt"
	"os"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

const (
	input      = "input.txt"
	test_input = "test_input.txt"
)

type pick struct {
	Qty   int
	Color string
}

func (p *pick) possible() bool {
	switch p.Color {
	case "red":
		return p.Qty <= maxRed.Qty
	case "green":
		return p.Qty <= maxGreen.Qty
	case "blue":
		return p.Qty <= maxBlue.Qty
	default:
		panic(fmt.Errorf("not a valid color: %s", p.Color))
	}
}

type game struct {
	ID    int
	Picks []pick
}

func (g *game) possible() bool {
	for _, p := range g.Picks {
		if !p.possible() {
			return false
		}
	}
	return true
}

func (g *game) minimumCubes() []int {
	var minima []int
	for _, color := range colors {
		var qtyOfColor []int
		for _, p := range g.Picks {
			if p.Color == color {
				qtyOfColor = append(qtyOfColor, p.Qty)
			}
		}
		minima = append(minima, slices.Max(qtyOfColor))
	}
	return minima
}

var (
	maxRed   = pick{12, "red"}
	maxGreen = pick{13, "green"}
	maxBlue  = pick{14, "blue"}
	colors   = []string{"red", "green", "blue"}
)

func main() {
	lines := getLines(test_input)
	//part1(lines)
	part2(lines)

}

func part1(rawGamesData []string) {
	var games []game
	var validIds []int

	for i, gameData := range rawGamesData {
		games = append(games, createGame(i+1, gameData))
	}

	for _, g := range games {
		if g.possible() {
			validIds = append(validIds, g.ID)
		}
	}

	sum := 0
	for _, id := range validIds {
		sum += id
	}

	fmt.Printf("Total of valid games Ids is %d", sum)
}

func createGame(id int, gd string) game {
	cleaned := cleanData(gd)
	picks := createPicks(cleaned)

	return game{id, picks}
}

func cleanData(d string) string {
	re := regexp.MustCompile(`Game \d+: `)
	d = re.ReplaceAllString(d, "")
	d = strings.ReplaceAll(d, ",", "")
	d = strings.ReplaceAll(d, ";", "")
	return d
}

func createPicks(gd string) []pick {
	var picks []pick
	re := regexp.MustCompile(`\d+ (blue|red|green)`)
	results := re.FindAllString(gd, -1)

	for _, p := range results {
		splitted := strings.Split(p, " ")
		qty, err := strconv.Atoi(splitted[0])
		if err != nil {
			panic(err)
		}
		picks = append(picks, pick{qty, splitted[1]})
	}
	return picks
}

func part2(rawGamesData []string) {
	var games []game
	for i, gameData := range rawGamesData {
		games = append(games, createGame(i+1, gameData))
	}

	var minima [][]int
	for _, g := range games {
		minima = append(minima, g.minimumCubes())
	}

	var minimaAsPowers []int
	for _, m := range minima {
		minimaAsPowers = append(minimaAsPowers, m[0]*m[1]*m[2])
	}

	sum := 0
	for _, power := range minimaAsPowers {
		sum += power
	}

	fmt.Printf("Total sum of powers is %d", sum)
}

func getLines(path string) []string {
	bytes, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return strings.Split(strings.TrimSpace(string(bytes)), "\n")
}
