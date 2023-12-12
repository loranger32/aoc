package main

import (
	"fmt"
	"os"
	"strings"
)

const (
	input        = "input.txt"
	testInput    = "test_input.txt"
	testInputBis = "test_input_bis.txt"
	startNode    = "AAA"
	endNode      = "ZZZ"
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

func (ns nodes) findStartNode() node {
	return ns.findNode(startNode)
}

func main() {
	instr, nodesSlice := getInstructionsAndNodes(input)

	currentNode := nodesSlice.findStartNode()
	counter := 0

	for i := 0; i < len(instr); i++ {
		if currentNode.name == endNode {
			break
		}
		currentNode = currentNode.findNext(instr[i], nodesSlice)
		fmt.Println(currentNode, i)
		counter++
		if i == len(instr)-1 {
			i = -1
		}
	}

	fmt.Println("Number of iterations: ", counter)
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
