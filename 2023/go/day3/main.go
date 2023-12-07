package main

import (
	"fmt"
	"math"
	"os"
	"regexp"
	"slices"
	"strconv"
	"strings"
)

const (
	input     = "input.txt"
	testInput = "test_input.txt"
)

type part struct {
	Y  int
	Xs []int
	id []string
}

func (p *part) Id() int {
	idStr := strings.Join(p.id, "")
	idInt, err := strconv.Atoi(idStr)
	if err != nil {
		panic(err)
	}
	return idInt
}

func (p *part) intersectSymbol(sym symbol) bool {
	if math.Abs(float64(p.Y)-float64(sym.y)) > 1 {
		return false
	}

	if sym.x >= (slices.Min(p.Xs)-1) && sym.x <= (slices.Max(p.Xs)+1) {
		return true
	}

	return false
}

type symbol struct {
	x, y int
	logo string
}

func (s *symbol) parts(parts []part) []part {
	var result []part
	for _, p := range parts {
		if p.intersectSymbol(*s) {
			result = append(result, p)
		}
	}
	return result
}

func (s *symbol) isGear(parts []part) (bool, []part) {
	var emptyResult []part

	if s.logo != "*" {
		return false, emptyResult
	}

	gearParts := s.parts(parts)

	if len(gearParts) == 2 {
		return true, gearParts
	} else {
		return false, emptyResult
	}
}

var reNumber = regexp.MustCompile(`\d`)

func main() {
	lines := getLines(input)
	//part1(lines)
	part2(lines)
}

func part1(lines []string) {
	parts, symbols := collectPartsAndSymbols(lines)

	realParts := retrieveRealParts(parts, symbols)

	sum := 0
	for _, rp := range realParts {
		//fmt.Printf("Part start X: %d, Y: %d, ID: %d\n", rp.Xs[0], rp.Y, rp.Id())
		sum += rp.Id()
	}

	fmt.Printf("The sum of parts ids is: %d\n", sum)
}

func part2(lines []string) {
	parts, symbols := collectPartsAndSymbols(lines)
	var gearsParts [][]part

	for _, s := range symbols {
		isGear, gpts := s.isGear(parts)
		if isGear {
			gearsParts = append(gearsParts, gpts)
		}
	}

	sum := 0
	for _, gp := range gearsParts {
		sum += gp[0].Id() * gp[1].Id()
	}
	fmt.Printf("The sum of all gears is: %d\n", sum)
}

func getLines(path string) []string {
	bytes, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return strings.Split(strings.TrimSpace(string(bytes)), "\n")
}

func collectPartsAndSymbols(lines []string) ([]part, []symbol) {
	var parts []part
	var symbols []symbol
	lineMaxLength := len(lines[0])

	p := part{}
	storing := false

	for idy, line := range lines {
		chars := strings.Split(line, "")
		for idx, char := range chars {
			if char == "." {
				if storing {
					parts = append(parts, p)
					storing = false
					p = part{}
				}
				continue
			}

			if reNumber.MatchString(char) {
				if storing {
					p.Xs = append(p.Xs, idx)
					p.id = append(p.id, char)
				} else {
					p = part{Y: idy, Xs: []int{idx}, id: []string{char}}
					storing = true
				}

				if idx == lineMaxLength-1 {
					parts = append(parts, p)
					storing = false
					p = part{}
				}
			} else {
				symbols = append(symbols, symbol{x: idx, y: idy, logo: char})
				if storing {
					parts = append(parts, p)
					storing = false
					p = part{}
				}
			}
		}
	}

	return parts, symbols
}

func retrieveRealParts(parts []part, symbols []symbol) []part {
	var realParts []part

	for _, p := range parts {
		for _, sym := range symbols {
			if p.intersectSymbol(sym) {
				realParts = append(realParts, p)
				break
			}
		}
	}
	return realParts
}
