package main

import (
	"cmp"
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

const (
	input     = "input.txt"
	testInput = "test_input.txt"
)

type tablePart struct {
	src, dst, rg int
}

type table []tablePart

func (t table) lowestSrc() int {
	// First tablePart has the lowest src
	return t[0].src
}

func (t table) convert(input int) int {
	output := input

	if input < t.lowestSrc() {
		return output
	}

	for _, tp := range t {
		if input >= tp.src && input < tp.src+tp.rg {
			output = tp.dst + (input - tp.src)
			break
		}
	}

	return output
}

type seedRange struct {
	start, end int
}

func (sr *seedRange) inRange(s int) bool {
	return s >= sr.start && s <= sr.end
}

func main() {
	rawData := getInput(input)
	//part1(rawData)
	part2(rawData)
}

func part1(data string) {
	splitted := strings.Split(data, "\n\n")
	seeds := getSeeds(splitted[0])
	almanac := generateAlmanac(splitted[1:])

	var locations []int

	for _, seed := range seeds {
		locations = append(locations, findLocation(seed, almanac))
	}

	lowest := slices.Min(locations)
	fmt.Printf("The lowest location is: %d\n", lowest)
}

// part 2 - starting from locations
func part2(data string) {
	splitted := strings.Split(data, "\n\n")
	seedRanges := getSeedRanges(splitted[0])
	almanac := generateAlmanac(splitted[1:])
	revAlmanac := reverseAlmanac(almanac)

	minLocation := findMinLocationFromLocations(seedRanges, revAlmanac)

	fmt.Println("The lowest location is: ", minLocation)
}

// part 2 - brute force with goroutines
//func part2(data string) {
//	splitted := strings.Split(data, "\n\n")
//	seedRanges := getSeedRanges(splitted[0])
//	almanac := generateAlmanac(splitted[1:])
//
//	wg := new(sync.WaitGroup)
//	wg.Add(len(seedRanges))
//	results := make(chan int, len(seedRanges))
//
//	for _, sr := range seedRanges {
//		srCopy := sr
//		go func(ch chan<- int) {
//			defer wg.Done()
//			location := 10_000_000_000
//			checkMinLocation(srCopy, almanac, &location)
//			fmt.Println("Chan minLocation: ", location)
//			ch <- location
//		}(results)
//	}
//
//	wg.Wait()
//
//	var minLocations []int
//	for r := range results {
//		minLocations = append(minLocations, r)
//		if len(results) == 0 {
//			break
//		}
//	}
//
//	minLocation := slices.Min(minLocations)
//	fmt.Printf("The lowest location is: %d\n", minLocation)
//}

// Part 2 - Brute force without threads
//func part2(data string) {
//	splitted := strings.Split(data, "\n\n")
//	seedRanges := getSeedRanges(splitted[0])
//	almanac := generateAlmanac(splitted[1:])
//	minLocation := 10_000_000_000
//
//	for _, sr := range seedRanges {
//		checkMinLocation(sr, almanac, &minLocation)
//	}
//
//	fmt.Printf("The lowest location is: %d\n", minLocation)
//}

func checkMinLocation(sr seedRange, almanac []table, minLocation *int) {
	end := sr.end
	for i := sr.start; i <= end; i++ {
		location := findLocation(i, almanac)
		if location < *minLocation {
			*minLocation = location
		}
	}
}

func getSeedRanges(l string) []seedRange {
	seedsIndicators := getSeeds(l)
	var seedRanges []seedRange

	for i, start := range seedsIndicators[:len(seedsIndicators)-1] {
		if i%2 != 0 {
			continue
		}
		seedRanges = append(seedRanges, seedRange{start: start, end: start + (seedsIndicators[i+1] - 1)})
	}

	return seedRanges
}

func generateAlmanac(data []string) []table {
	var almanac []table

	for _, tableData := range data {
		t := generateTable(tableData)
		almanac = append(almanac, t)
	}

	return almanac
}

func reverseAlmanac(almanac []table) []table {
	var revAlmanac []table

	for _, t := range almanac {
		var revTable table
		for _, tp := range t {
			revTable = append(revTable, tablePart{src: tp.dst, dst: tp.src, rg: tp.rg})
		}
		slices.SortFunc(revTable, func(a, b tablePart) int {
			return cmp.Compare(a.src, b.src)
		})

		revAlmanac = append([]table{revTable}, revAlmanac...)
	}
	return revAlmanac
}

func generateTable(tablesData string) table {
	var t table

	for _, tpData := range strings.Split(tablesData, "\n")[1:] {
		var tpElements []int
		for _, elStr := range strings.Split(tpData, " ") {
			elInt, err := strconv.Atoi(elStr)
			if err != nil {
				panic(err)
			}
			tpElements = append(tpElements, elInt)
		}

		t = append(t, tablePart{dst: tpElements[0], src: tpElements[1], rg: tpElements[2]})
	}

	slices.SortFunc(t, func(a, b tablePart) int {
		return cmp.Compare(a.src, b.src)
	})

	return t
}

func findLocation(seed int, almanac []table) int {
	output := seed

	for _, t := range almanac {
		output = t.convert(output)
	}

	return output
}

func getInput(path string) string {
	content, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	return strings.TrimSpace(string(content))
}

func getSeeds(l string) []int {
	var seeds []int

	for _, ss := range strings.Split(l, " ")[1:] {
		si, err := strconv.Atoi(ss)
		if err != nil {
			panic(err)
		}
		seeds = append(seeds, si)
	}

	return seeds
}

func findMinLocationFromLocations(seedRanges []seedRange, revAlmanac []table) int {
	maxLocation := 10_000_000_000
	var minLocation int

	for l := 0; l < maxLocation; l++ {
		potentialSeed := findLocation(l, revAlmanac)
		if seedAvailable(potentialSeed, seedRanges) {
			minLocation = l
			break
		}
	}

	return minLocation
}

func seedAvailable(seed int, seedRanges []seedRange) bool {
	for _, sr := range seedRanges {
		if sr.inRange(seed) {
			return true
		}
	}

	return false
}
