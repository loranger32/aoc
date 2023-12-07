package main

import (
	"bufio"
	"os"
	"slices"
	"strconv"
	"strings"
)

const input string = "input.txt"
//goos: linux
//goarch: amd64
//pkg: 1
//cpu: Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz
//BenchmarkFunctionalStyle
//BenchmarkFunctionalStyle-8     	   10837	    117811 ns/op	   91752 B/op	     286 allocs/op
//BenchmarkOneAtATimeStyle
//BenchmarkOneAtATimeStyle-8     	   19826	     60676 ns/op	    4216 B/op	       4 allocs/op
//BenchmarkThreeAtATimeStyle
//BenchmarkThreeAtATimeStyle-8   	   17696	     67606 ns/op	    4216 B/op	       4 allocs/op
//PASS
//ok  	1	6.229s

func main() {
	threeAtATime(input)
	//oneAtATimeStyle(input)
	//functionalStyle(input)
}

func checkMaxBags(first, second, third, bag int) (int, int, int, int) {
	if bag > first {
		third, second, first, bag = second, first, bag, 0
		return first, second, third, bag
	}

	if bag > second {
		third, second, bag = second, bag, 0
		return first, second, third, bag
	}

	if bag > third {
		third, bag = bag, 0
		return first, second, third, bag
	}

	return first, second, third, 0
}

func threeAtATime(input string) {
	file, err := os.Open(input)
	if err != nil {
		panic(err)
	}

	first := 0
	second := 0
	third := 0
	scanner := bufio.NewScanner(file)

	bag := 0

	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if len(line) == 0 {
			first, second, third, bag = checkMaxBags(first, second, third, bag)
		} else {
			cals, err := strconv.Atoi(line)
			if err != nil {
				panic(err)
			}
			bag += cals
		}
	}
	first, second, third, _ = checkMaxBags(first, second, third, bag)
}

func oneAtATimeStyle(input string) {
	file, err := os.Open(input)
	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(file)

	maxBag := 0
	bag := 0
	counter := 0

	for scanner.Scan() {
		line := scanner.Text()
		if len(line) == 0 {
			counter += 1
			if bag > maxBag {
				maxBag = bag
			}
			bag = 0
			continue
		} else {
			cals, err := strconv.Atoi(line)
			if err != nil {
				panic(err)
			}
			bag += cals
		}
	}
	counter += 1
	if bag > maxBag {
		maxBag = bag
	}
}

func functionalStyle(input string) {
	// 1. One Big string
	rawContent := retrieveInput(input)

	// 2. One slice of strings
	rawBags := strings.Split(rawContent, "\n\n")

	// 3.One slice of slices of strings
	bagsAsStr := splitBags(rawBags)

	// 4. One slice ints
	bagsInt := computeBagsCal(bagsAsStr)
	slices.Sort(bagsInt)

	// 5. Get the max int
	//fmt.Printf("Bag with most calories has %d\n", bagsInt[len(bagsInt)-1])

	// 6. get the first 3 max ints
	//fmt.Printf("%v", bagsInt[len(bagsInt)-3:])
	//fmt.Printf("Total calories of the three biggest bags : %d", threeBiggestBagTotalCal(bagsInt))
}

func computeBagsCal(bagsAsStr [][]string) []int {
	bagsInt := []int{}

	for _, bagStr := range bagsAsStr {
		bag := 0

		for _, snack := range bagStr {
			cal, err := strconv.Atoi(snack)
			if err != nil {
				panic(err)
			}
			bag += cal
		}
		bagsInt = append(bagsInt, bag)
	}
	return bagsInt
}

func retrieveInput(input string) string {
	rawContent, err := os.ReadFile("input.txt")
	if err != nil {
		panic(err)
	}
	return strings.TrimSpace(string(rawContent))
}

func splitBags(rawBags []string) [][]string {
	bagsAsStr := [][]string{}

	for _, bagStr := range rawBags {
		bagsAsStr = append(bagsAsStr, strings.Split(bagStr, "\n"))
	}
	return bagsAsStr
}

func threeBiggestBagTotalCal(bags []int) int {
	total := 0
	for _, bag := range bags[len(bags)-3:] {
		total += bag
	}
	return total
}
