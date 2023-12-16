package main

import (
	"fmt"
	"os"
	"slices"
	"strings"
)

const (
	input     = "input.txt"
	testInput = "test_input.txt"
	startNode = "AAA"
	endNode   = "ZZZ"
)

type node struct {
	name, left, right string
}

func (n *node) findNext(instruction string, nodesSlice nodes) node {
	if instruction == "L" {
		return nodesSlice.findNode(n.left)
	} else {
		return nodesSlice.findNode(n.right)
	}
}

type nodes []node

func (ns nodes) findNode(nodeName string) node {
	var newNode node
	for _, n := range ns {
		if n.name == nodeName {
			newNode = n
			break
		}
	}
	return newNode
}

func (ns nodes) findStartingNodes() nodes {
	var sn nodes
	for _, n := range ns {
		if strings.HasSuffix(n.name, "A") {
			sn = append(sn, n)
		}
	}
	return sn
}

func (ns nodes) step(instr string, allNodes nodes) nodes {
	for i, n := range ns {
		ns[i] = n.findNext(instr, allNodes)
	}
	return ns
}

func main() {
	instr, nodesSlice := getInstructionsAndNodes(input)

	currentNodes := nodesSlice.findStartingNodes()
	totalStartingNodes := len(currentNodes)
	counter := 0
	var firstEnd []int

	for i := 0; i < len(instr); i++ {
		counter++
		currentNodes = currentNodes.step(instr[i], nodesSlice)

		// Basic approach here would be to check after every step if all paths are ended
		// But it takes forever, solution has 13 digits...
		// Because the input has been carefully crafted, all 6 paths are cyclic and repeat themselves forever.
		// So the LCM approach is possible, and very efficient here.

		currentNodes = handleEndOfPath(currentNodes, counter, &firstEnd)
		if len(firstEnd) == totalStartingNodes {
			break
		}

		if i == len(instr)-1 {
			// -1 to account for the i++
			i = -1
		}
	}

	computedLcm := lcm(firstEnd[0], firstEnd[1], firstEnd[2:]...)
	fmt.Println("Number of iterations: ", computedLcm)
}

func handleEndOfPath(currentNodes nodes, counter int, firstEnd *[]int) nodes {
	for i, n := range currentNodes {
		if strings.HasSuffix(n.name, "Z") {
			*firstEnd = append(*firstEnd, counter)
			currentNodes = slices.Delete(currentNodes, i, i+1)
		}
	}

	return currentNodes
}

func getInstructionsAndNodes(path string) ([]string, nodes) {
	raw, err := os.ReadFile(path)
	if err != nil {
		panic(err)
	}

	splitted := strings.Split(strings.TrimSpace(string(raw)), "\n\n")
	instr := strings.Split(splitted[0], "")
	nodesSlice := getNodes(splitted[1])
	return instr, nodesSlice
}

func getNodes(rawNodes string) nodes {
	var n nodes
	for _, rawNode := range strings.Split(rawNodes, "\n") {
		n = append(n, node{rawNode[:3], rawNode[7:10], rawNode[12:15]})
	}

	return n
}

// Source for gcd and lcm : https://siongui.github.io/2017/06/03/go-find-lcm-by-gcd/
func gcd(a, b int) int {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

// find Least Common Multiple (LCM) via GCD
func lcm(a, b int, integers ...int) int {
	result := a * b / gcd(a, b)

	for i := 0; i < len(integers); i++ {
		result = lcm(result, integers[i])
	}

	return result
}
