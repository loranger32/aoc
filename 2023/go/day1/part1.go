package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const (
	input          = "input.txt"
	test_input     = "test_input.txt"
	test_input_bis = "test_input_bis.txt"
)

var spelledOut = map[string]string{"one": "1", "two": "2", "three": "3", "four": "4", "five": "5", "six": "6",
	"seven": "7", "eight": "8", "nine": "9"}

func main() {
	calibrations := getLines(input)
	//part1(calibrations)
	part2(calibrations)

}

func part2(calibrations []string) {
	var digitsStr [][]string
	for _, cd := range calibrations {
		digitsStr = append(digitsStr, findAllDigits(cd))
	}

	var convertedDigitStr [][]string
	for _, cds := range digitsStr {
		convertedDigitStr = append(convertedDigitStr, convertSpelledOut(cds))
	}

	var numbers []int
	for _, digits := range convertedDigitStr {
		numbers = append(numbers, extractNumber(digits))
	}

	sum := 0
	for _, n := range numbers {
		sum += n
	}

	fmt.Printf("The total of calibration data is: %v\n", sum)
}

func part1(calibrations []string) {
	var digitsStr [][]string
	for _, cd := range calibrations {
		digitsStr = append(digitsStr, findDigits(cd))
	}

	var numbers []int
	for _, digits := range digitsStr {
		numbers = append(numbers, extractNumber(digits))
	}

	sum := 0
	for _, n := range numbers {
		sum += n
	}

	fmt.Printf("The total of calibration data is: %v", sum)
}

func extractNumber(ds []string) int {
	n := strings.Join(ds, "")
	i, err := strconv.Atoi(n)
	if err != nil {
		panic(err)
	}
	return i
}

func getLines(path string) []string {
	b, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}
	s := strings.TrimSpace(string(b))
	return strings.Split(s, "\n")
}

func findDigits(calibration string) []string {
	re := regexp.MustCompile(`\d`)
	digits := re.FindAllString(calibration, -1)
	return []string{digits[0], digits[len(digits)-1]}
}

func findAllDigits(calibration string) []string {
	var result []string
	chars := strings.Split(calibration, "")
	for i := 0; i < len(calibration); i++ {
		_, err := strconv.Atoi(chars[i])
		if err == nil {
			result = append(result, chars[i])
			continue
		}

		for spelled, digit := range spelledOut {
			if strings.HasPrefix(calibration[i:], spelled) {
				result = append(result, digit)
				break
			}
		}
	}
	return []string{result[0], result[len(result)-1]}
}

func convertSpelledOut(digits []string) []string {
	var result []string
	for _, digit := range digits {
		d := digit
		val, exist := spelledOut[d]
		if exist {
			d = val
		}
		result = append(result, d)
	}
	return result
}
