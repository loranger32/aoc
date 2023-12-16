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

func main() {
	sequences := extractSequences(input)

	for notAllzeroed(sequences) {
		for i, seq := range sequences {
			if notZeroed(seq[len(seq)-1]) {
				sequences[i] = append(sequences[i], computeDifferences(seq[len(seq)-1]))
			}
		}
	}

	extrpolations := make([]int, 0, len(sequences))

	for _, sequence := range sequences {
		counter := 0

		for i := len(sequence) - 2; i >= 0; i-- {
			counter += sequence[i][len(sequence[i])-1]
		}

		extrpolations = append(extrpolations, counter)
	}

	sum := 0
	for _, extrextrpolation := range extrpolations {
		sum += extrextrpolation
	}

	fmt.Printf("The sum of all extrapolations is %d\n", sum)

}

func computeDifferences(input []int) []int {
	output := make([]int, 0, len(input)-1)

	for i := len(input) - 1; i > 0; i-- {
		output = append([]int{input[i] - (input[i-1])}, output...)
	}

	return output
}

func notAllzeroed(sequences [][][]int) bool {
	for _, seqs := range sequences {
		if notZeroed(seqs[len(seqs)-1]) {
			return true
		}
	}
	return false
}

func notZeroed(seq []int) bool {
	for _, num := range seq {
		if num != 0 {
			return true
		}
	}

	return false
}

func extractSequences(path string) [][][]int {
	raw, err := os.ReadFile(path)

	if err != nil {
		panic(err)
	}

	lines := strings.Split(string(raw), "\n")
	sequences := make([][]int, 0, len(lines))

	for _, line := range lines {
		seqStr := strings.Fields(line)
		seqInt := make([]int, 0, len(seqStr))

		for _, numStr := range seqStr {
			numInt, err := strconv.Atoi(numStr)
			if err != nil {
				panic(err)
			}
			seqInt = append(seqInt, numInt)
		}
		sequences = append(sequences, seqInt)
	}

	oasis := make([][][]int, len(lines))

	for i, seq := range sequences {

		oasis[i] = append(oasis[i], seq)
	}

	return oasis
}
